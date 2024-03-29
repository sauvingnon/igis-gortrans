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
    static let shared = ShowTransportStopViewModel()
    private init(){
        
    }
    
    @Published var model = ShowStopOnlineModel.shared
    
    func showData(){
        withAnimation{
            model.opacity = 1.0
        }
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
        }
    }
    
    func getStationData(){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            self.clearStationView()
            while(ServiceSocket.status != .connected){
                
            }
            if let object = try? MessagePackEncoder().encode(StationRequest(stop_id: self.model.stopId)){
                ServiceSocket.shared.emitOn(event: "cliSerSubscribeTo", items: object)
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
        
//        self.getStationData()
    }
    
    func disconfigureView(){
//        ServiceSocket.shared.unsubscribeCliSerSubscribeToEvent()
    }
    
    func updateStaionScreen(obj: StationResponse){
        if(!obj.data.citybus.isEmpty){
            var buses: [TransportWaiter] = []
            obj.data.citybus.forEach { item in
                buses.append(TransportWaiter(transportNumber: DataBase.getRouteNumber(routeId: item.route.id), endStationName:  DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), time: GeneralViewModel.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.model.buses = buses
            }
        }
        
        if(!obj.data.suburbanbus.isEmpty){
            var countryBuses: [TransportWaiter] = []
            obj.data.suburbanbus.forEach { item in
                countryBuses.append(TransportWaiter(transportNumber: DataBase.getRouteNumber(routeId: item.route.id), endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), time: GeneralViewModel.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.model.countryBuses = countryBuses
            }
        }
        
        if(!obj.data.tram.isEmpty){
            var trains: [TransportWaiter] = []
            obj.data.tram.forEach { item in
                trains.append(TransportWaiter(transportNumber: DataBase.getRouteNumber(routeId: item.route.id), endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), time: GeneralViewModel.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.model.trains = trains
            }
        }
        
        if(!obj.data.trolleybus.isEmpty){
            var trolleybuses: [TransportWaiter] = []
            obj.data.trolleybus.forEach { item in
                trolleybuses.append(TransportWaiter(transportNumber: DataBase.getRouteNumber(routeId: item.route.id), endStationName: item.finish.first?.stop.name ?? "—", time: GeneralViewModel.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? 0)))
            }
            DispatchQueue.main.async {
                self.model.trolleybuses = trolleybuses
            }
        }
        DispatchQueue.main.async {
            self.model.showIndicator = false
            self.showData()
        }
    }
}
