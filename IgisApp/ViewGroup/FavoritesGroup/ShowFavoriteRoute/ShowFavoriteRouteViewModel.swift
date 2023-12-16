//
//  ShowFavoriteRouteViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import Foundation
import MessagePacker
import SwiftUI

class ShowFavoriteRouteViewModel {
    static let shared = ShowFavoriteRouteViewModel()
    private init(){
        
    }
    
    private let model = ShowFavoriteRouteModel.shared
    private var alertAlreadyPresented = false
    
    func favoriteRouteTapped(){
        if var favoritesArray = UserDefaults.standard.array(forKey: "FavoriteRoutes") as? [Int]{
            if GeneralViewModel.isFavoriteRoute(routeId: model.routeId){
                favoritesArray.removeAll { item in
                    item == model.routeId
                }
                model.isFavorite = false
            }else{
                favoritesArray.append(model.routeId)
                model.isFavorite = true
            }
            favoritesArray.sort()
            UserDefaults.standard.set(favoritesArray, forKey: "FavoriteRoutes")
            
        }else{
            UserDefaults.standard.set([model.routeId], forKey: "FavoriteRoutes")
        }
        FavoritesRoutesAndStationsModel.shared.favoriteRoutes = GeneralViewModel.getFavoriteRouteData()
    }
    
    func configureView(routeId: Int, type: TypeTransport, number: String){
        
        model.type = type
        model.name = getName(type: type, number: number)
        model.routeId = routeId
        model.isFavorite = GeneralViewModel.isFavoriteRoute(routeId: routeId)
        model.number = number
            
        fillMenu()
        presentRoute()
        getRouteData()
    }
    
    func getRouteData(){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            while(ServiceSocket.status != .connected){
                
            }
            if let object = try? MessagePackEncoder().encode(RouteRequest(route_number: self.model.number, transport_type: self.model.type)){
                ServiceSocket.shared.emitOn(event: "cliSerSubscribeTo", items: object, updateScreen: "ShowFavoriteRoute")
                debugPrint("Запрос к серверу на получение прогноза избранного маршрута транспорта.")
            }else{
                debugPrint("Запрос для получения прогноза избранного маршрута транспорта не отправлен.")
            }
        }
    }
    
    func updateRouteScreen(obj: RouteResponse){
        var result: [Station] = []
        
        if(obj.data.notwork.code != "online" && obj.data.notwork.code != "noAnything" && !alertAlreadyPresented){
            debugPrint("статус маршрута не рабочий - \(obj.data.notwork.code)")
            if let description = GeneralViewModel.setAttributedStringFromHTML(htmlText: obj.data.notwork.description){
                AppTabBarViewModel.shared.showAlert(title: "Маршрут не работает.", message: "\(description) - (\(obj.data.notwork.code))")
            }else{
                AppTabBarViewModel.shared.showAlert(title: "Маршрут не работает.", message: "Код причины - (\(obj.data.notwork.code))")
                debugPrint("Не удалось раскодировать html строку!")
            }
            
            alertAlreadyPresented = true
            return
        }
        
        let notSeenTransport = (obj.data.notwork.network.first ?? 0) - (obj.data.notwork.network.last ?? 0)
        if(notSeenTransport != 0){
            debugPrint("На маршруте не отображается \(notSeenTransport) единиц/ы транспорта")
        }
        
        model.data.forEach({ stationView in
            
            if let findStation = obj.data.scheme.first(where: { item in
                return item.stop == String(stationView.id)
            }){
                if(findStation.ts.count == 0){
                    if(findStation.sec > 3600){
                        result.append(Station(id: stationView.id, name: stationView.name, stationState: stationView.stationState, pictureTs: "", time: String((findStation.time) ?? GeneralViewModel.getTimeToArrivalInMin(sec: findStation.sec))))
                    }else{
                        result.append(Station(id: stationView.id, name: stationView.name, stationState: stationView.stationState, pictureTs: "", time: GeneralViewModel.getTimeToArrivalInMin(sec: findStation.sec)))
                    }
                }else{
                    result.append(Station(id: stationView.id, name: stationView.name, stationState: stationView.stationState, pictureTs: GeneralViewModel.getPictureTransport(type: (findStation.ts.first!.ts_type)), time: GeneralViewModel.getTimeToArrivalInMin(sec: findStation.sec), transportId: findStation.ts.first?.id))
                }
            }
        })
        
        obj.data.scheme.forEach { item in
            if(item.stop.contains("-")){
                let stop_id = String(item.stop.split(separator: "-").last ?? "0")
                if let stationIndex = result.firstIndex(where: { station in
                    String(station.id) == stop_id
                }){
                    result[stationIndex].isNext = true
                    result[stationIndex].pictureTs = GeneralViewModel.getPictureTransport(type: (item.ts.first!.ts_type))
                    result[stationIndex].transportId = item.ts.first?.id
                }
            }
        }
        
        DispatchQueue.main.async {
            self.model.data = result
        }
    }
    
    func presentRoute( direction: Direction? = nil){
        // Метод для отображения маршрута на экране
        var stopsOfRoute: [Int] = []
        
        // Получим все направления этого маршрута - массив направлений
        // Направление - массив остановок
        if let allSubroutesThisRoute = DataBase.getStopsOfRoute(routeId: model.routeId){
            
            // Если направление задано, то отобразим именно его
            if direction != nil{
                // Получим то направление, которое удовлетворяет нашему условию
                stopsOfRoute = allSubroutesThisRoute.first(where: { item in
                    item.subroute_stops.first == direction?.startStation && item.subroute_stops.last == direction?.endStation
                })?.subroute_stops ?? []
            }else{
                // Иначе отобразим приоритетное направление маршрута, это то у которого subroute_main = 1
                // Если и такого нет - отобразим первое попавшиеся - иначе пустой массив
                stopsOfRoute = allSubroutesThisRoute.first(where: { item in
                    item.subroute_main == 1
                })?.subroute_stops ?? allSubroutesThisRoute.first?.subroute_stops ?? []
            }
        }
        
        model.data.removeAll()
        
        // Заполнение вью полученным направлением - массивом остановок
        var stationState = StationState.startStation
        
        stopsOfRoute.forEach { stopId in
            if(stopId == stopsOfRoute.last) { stationState = .endStation }
            withAnimation {
                model.data.append(Station(id: stopId, name: DataBase.getStopName(stopId: stopId), stationState: stationState, pictureTs: "", time: "--"))
            }
            stationState = .someStation
        }
        
        getRouteData()
        alertAlreadyPresented = false
    }
    
    func fillMenu(){
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            self.model.menu.menuItems.removeAll()
            
            var offset = 50
            if let allSubroutesThisRoute = DataBase.getStopsOfRoute(routeId: self.model.routeId){
                
                allSubroutesThisRoute.forEach { direction in
                    self.model.menu.menuItems.append(MenuItem(startStopId: direction.subroute_stops.first ?? 0, endStopId: direction.subroute_stops.last ?? 0, offset: offset))
                    offset += 50
                }
                
                let firstDirection = allSubroutesThisRoute.first?.subroute_stops
                
                self.model.menu.currentStop = MenuItem(startStopId: firstDirection?.first ?? 0, endStopId: firstDirection?.last ?? 0, offset: 0)
            }
        }
    }
    
    func getName(type: TypeTransport, number: String) -> String {
        switch type {
        case .bus:
            return "АВТОБУС №\(number)"
        case .train:
            return "ТРАМВАЙ №\(number)"
        case .trolleybus:
            return "ТРОЛЛЕЙБУС №\(number)"
        case .countrybus:
            return "АВТОБУС №\(number)"
        }
    }
}
