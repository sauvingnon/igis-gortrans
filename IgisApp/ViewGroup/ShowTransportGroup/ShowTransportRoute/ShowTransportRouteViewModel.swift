//
//  ShowTransportRouteViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.11.2023.
//

import Foundation
import SwiftUI
import MessagePacker

class ShowTransportRouteViewModel{
    
    static let shared = ShowTransportRouteViewModel()
    private init(){
        
    }
    
    private let model = ShowTransportRouteModel.shared
    
//    func handleRouteData(){
//        ServiceSocket.shared.socket.on("serCliDataInPage") { some1, some2 in
////            let queue = DispatchQueue.global(qos: .default)
////            queue.async {
//                if let obj = try? MessagePackDecoder().decode(RouteResponse.self, from: some1.first as! Data){
//                    debugPrint("был получен прогноз маршрута \(Date.now)")
//                    ShowTransportRouteViewModel.shared.updateRouteScreen(obj: obj)
//                    return
//                }
//                debugPrint("ошибка расшифровки ответа от сервера \(Date.now)")
//        }
//    }
    
    func getRouteData(){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            while(ServiceSocket.status != .connected){
                
            }
            if let object = try? MessagePackEncoder().encode(RouteRequest(route_number: self.model.number, transport_type: self.model.type)){
                ServiceSocket.shared.subscribeOn(event: "cliSerSubscribeTo", items: object)
                debugPrint("Запрос к серверу на получение прогноза маршрута транспорта.")
            }else{
                debugPrint("Запрос для получения прогноза маршрута не отправлен.")
            }
        }
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
        
        self.getRouteData()
//        self.handleRouteData()
    }
    
    func configureView(routeId: Int, type: TypeTransport, number: String){
        
        ShowTransportRouteModel.shared.type = type
        ShowTransportRouteModel.shared.name = getName(type: type, number: number)
        ShowTransportRouteModel.shared.routeId = routeId
        ShowTransportRouteModel.shared.isFavorite = Model.isFavoriteRoute(routeId: routeId)
        ShowTransportRouteModel.shared.number = number
        
        fillMenu()
        presentRoute()
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
    
    func updateRouteScreen(obj: RouteResponse){
        var result: [Station] = []
        
        if(obj.data.notwork.code != "online" && obj.data.notwork.code != "noAnything"){
            debugPrint("статус маршрута не рабочий - \(obj.data.notwork.code)")
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
                        result.append(Station(id: stationView.id, name: stationView.name, stationState: stationView.stationState, pictureTs: "", time: String((findStation.time) ?? Model.getTimeToArrivalInMin(sec: findStation.sec))))
                    }else{
                        result.append(Station(id: stationView.id, name: stationView.name, stationState: stationView.stationState, pictureTs: "", time: Model.getTimeToArrivalInMin(sec: findStation.sec)))
                    }
                }else{
                    result.append(Station(id: stationView.id, name: stationView.name, stationState: stationView.stationState, pictureTs: Model.getPictureTransport(type: (findStation.ts.first!.ts_type)), time: Model.getTimeToArrivalInMin(sec: findStation.sec), transportId: findStation.ts.first?.id))
                }
            }
        })
        
        obj.data.scheme.forEach { item in
            if(item.stop.contains("-")){
                let stop_id = String(item.stop.split(separator: "-").last ?? "0")
                if let stationIndex = result.firstIndex(where: { station in
                    String(station.id) == stop_id
                }){
                    debugPrint("был отображен транспорт подьезд")
                    result[stationIndex].isNext = true
                    result[stationIndex].pictureTs = Model.getPictureTransport(type: (item.ts.first!.ts_type))
                    result[stationIndex].transportId = item.ts.first?.id
                }
            }
        }
        
        DispatchQueue.main.async {
            self.model.data = result
        }
    }
    
}
