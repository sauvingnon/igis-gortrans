//
//  ShowTransportStopViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.11.2023.
//

import Foundation
import SwiftUI
import MessagePacker

class ShowTransportStopViewModel: ObservableObject {

    @Published var model = ShowStopOnlineModel()
    
    func showData(){
        withAnimation{
            model.opacity = 1.0
        }
    }
    
    func eraseCallBack(){
        
    }
    
    func favoriteStopTapped(){
        if var favoritesArray = UserDefaults.standard.array(forKey: "FavoriteStops") as? [Int]{
            if GeneralViewModel.isFavoriteStop(stopId: model.stopId){
                favoritesArray.removeAll { item in
                    item == model.stopId
                }
                model.isFavorite = false
            }else{
                favoritesArray.append(model.stopId)
                model.isFavorite = true
            }
            favoritesArray.sort()
            UserDefaults.standard.set(favoritesArray, forKey: "FavoriteStops")
            
        }else{
            UserDefaults.standard.set([model.stopId], forKey: "FavoriteStops")
        }
        FavoritesRoutesAndStationsModel.shared.favoriteStops = GeneralViewModel.getFavoriteStopData()
    }
    
    func clearStationView(){
        DispatchQueue.main.async {
            self.model.opacity = 0
            self.model.buses.removeAll()
            self.model.countryBuses.removeAll()
            self.model.trains.removeAll()
            self.model.trolleybuses.removeAll()
            self.model.showIndicator = true
            self.objectWillChange.send()
        }
    }
    
    func showStopOnMap(){
        guard let stopAnnotation = MapModel.shared.stopAnnotations.filter({ annotation in
            annotation.stop_id == model.stopId
        }).first else { return }
        
        MapGroupStackManager.shared.clearNavigationStack()
        AppTabBarViewModel.shared.showPage(tab: .map)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            MapViewModel.shared.selectStopAnnotation(stopAnnotation: stopAnnotation, showOnlyOneAnnotation: true)
        })
    }
    
    func getStationData(){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            self.clearStationView()
            while(ServiceSocket.status != .connected){
                
            }
            if let object = try? MessagePackEncoder().encode(StationRequest(stop_id: self.model.stopId)){
                ServiceSocket.shared.emitOn(event: "cliSerSubscribeTo", items: object, callback: self.updateStaionScreen)
                debugPrint("Запрос к серверу на получение прогноза остановки транспорта.")
            }else{
                debugPrint("Запрос для получения прогноза остановки транспорта не отправлен.")
            }
        }
    }
    
    func configureView(stop_id: Int){
        self.model.stopId = stop_id
        self.model.name = DataBase.getStopName(stopId: stop_id)
        self.model.direction = DataBase.getStopDirection(stopId: stop_id)
        self.model.isFavorite = GeneralViewModel.isFavoriteStop(stopId: stop_id)
        
        FireBaseService.shared.showStopViewOpened(name: self.model.name)
//        self.getStationData()
    }
    
    func disconfigureView(){
//        ServiceSocket.shared.unsubscribeCliSerSubscribeToEvent()
    }
    
    
    
    func showAlertBadResponse(){
        if(model.alertAlreadyShow){
            return
        }
        DispatchQueue.main.async {
            AppTabBarViewModel.shared.showAlert(title: "Нет сведений о данной остановке", message: "Нет данных")
            self.model.alertAlreadyShow = true
        }
    }
    
    func updateStaionScreen(data: Data){
        
        guard let obj = try? MessagePackDecoder().decode(StationResponse.self, from: data)else {
            debugPrint("Ошибка при декодировании объекта StationResponse \(Date.now)")
            if(model.showIndicator){
                showAlertBadResponse()
            }
            return
        }
        
        debugPrint("были получены данные о остановке \(Date.now)")
        
        // Правка для автобуса и троллейбуса, так как время прибытия неакт, но факт прибытия акт.
        
        if(!obj.data.citybus.isEmpty){
            var buses: [TransportWaiter] = []
            obj.data.citybus.forEach { item in
                
//                buses.append(TransportWaiter(transportNumber: DataBase.getRouteNumberForFetch(routeId: item.route.id), routeId: item.route.id, type: .bus, endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), stopId: item.finish.first?.stop.id ?? 0, time: GeneralViewModel.getTimeToArrivalInMinWithoutLetters(sec: item.finish.first?.sec ?? -1)))
                
                buses.append(
                    TransportWaiter(
                        transportNumber: DataBase.getRouteNumberForFetch(routeId: item.route.id),
                        routeId: item.route.id,
                        type: .bus,
                        endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0),
                        stopId: item.finish.first?.stop.id ?? 0,
                        time: GeneralViewModel.getTimeToArrivalInMinWithoutLetters(sec: -1)
                    )
                )
            }
            DispatchQueue.main.async {
                self.model.buses = buses
            }
        }
        
        if(!obj.data.suburbanbus.isEmpty){
            var countryBuses: [TransportWaiter] = []
            obj.data.suburbanbus.forEach { item in
                
//                countryBuses.append(TransportWaiter(transportNumber: DataBase.getRouteNumberForFetch(routeId: item.route.id), routeId: item.route.id, type: .countrybus, endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), stopId: item.finish.first?.stop.id ?? 0, time: GeneralViewModel.getTimeToArrivalInMinWithoutLetters(sec: item.finish.first?.sec ?? -1)))
                
                countryBuses.append(
                    TransportWaiter(
                        transportNumber: DataBase.getRouteNumberForFetch(routeId: item.route.id),
                        routeId: item.route.id,
                        type: .countrybus,
                        endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0),
                        stopId: item.finish.first?.stop.id ?? 0,
                        time: GeneralViewModel.getTimeToArrivalInMinWithoutLetters(sec: -1)
                    )
                )
                
            }
            DispatchQueue.main.async {
                self.model.countryBuses = countryBuses
            }
        }
        
        if(!obj.data.tram.isEmpty){
            var trains: [TransportWaiter] = []
            obj.data.tram.forEach { item in
                trains.append(TransportWaiter(transportNumber: DataBase.getRouteNumberForFetch(routeId: item.route.id), routeId: item.route.id, type: .train, endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), stopId: item.finish.first?.stop.id ?? 0, time: GeneralViewModel.getTimeToArrivalInMinWithoutLetters(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.model.trains = trains
            }
        }
        
        if(!obj.data.trolleybus.isEmpty){
            var trolleybuses: [TransportWaiter] = []
            obj.data.trolleybus.forEach { item in
                trolleybuses.append(TransportWaiter(transportNumber: DataBase.getRouteNumberForFetch(routeId: item.route.id), routeId: item.route.id, type: .trolleybus, endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), stopId: item.finish.first?.stop.id ?? 0, time: GeneralViewModel.getTimeToArrivalInMinWithoutLetters(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.model.trolleybuses = trolleybuses
            }
        }
        DispatchQueue.main.async {
            self.model.showIndicator = false
            self.showData()
            self.objectWillChange.send()
        }
    }
}
