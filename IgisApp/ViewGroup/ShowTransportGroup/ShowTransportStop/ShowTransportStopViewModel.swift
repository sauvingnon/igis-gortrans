//
//  ShowTransportStopViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.11.2023.
//

import Foundation
import SwiftUI
import MessagePacker

class ShowTransportStopViewModel {
    static let shared = ShowTransportStopViewModel()
    private init(){
        
    }
    
    private let model = ShowStopOnlineModel.shared
    
    func showData(){
        withAnimation{
            ShowStopOnlineModel.shared.opacity = 1.0
        }
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
        queue.sync {
            self.clearStationView()
            while(ServiceSocket.status != .connected){
                
            }
            if let object = try? MessagePackEncoder().encode(StationRequest(stop_id: model.stopId)){
                ServiceSocket.shared.subscribeOn(event: "cliSerSubscribeTo", items: object)
                debugPrint("Запрос к серверу на получение прогноза остановки транспорта.")
            }else{
                debugPrint("Запрос для получения прогноза остановки транспорта не отправлен.")
            }
        }
    }
    
    func configureView(stop_id: Int){
        ShowStopOnlineModel.shared.stopId = stop_id
        ShowStopOnlineModel.shared.name = DataBase.getStopName(stopId: stop_id)
        ShowStopOnlineModel.shared.direction = DataBase.getStopDirection(stopId: stop_id)
        ShowStopOnlineModel.shared.isFavorite = Model.isFavoriteStop(stopId: stop_id)
        
        getStationData()
    }
    
    func updateStaionScreen(obj: StationResponse){
        if(!obj.data.citybus.isEmpty){
            var buses: [TransportWaiter] = []
            obj.data.citybus.forEach { item in
                buses.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName:  DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.model.buses = buses
            }
        }
        
        if(!obj.data.suburbanbus.isEmpty){
            var countryBuses: [TransportWaiter] = []
            obj.data.suburbanbus.forEach { item in
                countryBuses.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.model.countryBuses = countryBuses
            }
        }
        
        if(!obj.data.tram.isEmpty){
            var trains: [TransportWaiter] = []
            obj.data.tram.forEach { item in
                trains.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.model.trains = trains
            }
        }
        
        if(!obj.data.trolleybus.isEmpty){
            var trolleybuses: [TransportWaiter] = []
            obj.data.trolleybus.forEach { item in
                trolleybuses.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: item.finish.first?.stop.name ?? "--", time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? 0)))
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
