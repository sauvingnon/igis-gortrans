//
//  ShowTransportUnitViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.11.2023.
//

import Foundation
import SwiftUI
import MapKit
import MessagePacker

class ShowTransportUnitViewModel{
    static let shared = ShowTransportUnitViewModel()
    private init(){
        
    }
    private let model = ShowTransportUnitModel.shared
    
    func showData(){
        self.model.showIndicator = false
        withAnimation{
            self.model.opacity = 1
        }
        self.model.objectWillChange.send()
    }
    
    func disconfigureView(){
//        ServiceSocket.shared.unsubscribeCliSerSubscribeToEvent()
    }
    
    func getTransportData(){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            if(ServiceSocket.status != .connected){
                self.model.opacity = 0
            }
            while(ServiceSocket.status != .connected){
            }
            if let object = try? MessagePackEncoder().encode(TransportRequest(transportId: self.model.transportId)){
                ServiceSocket.shared.emitOn(event: "cliSerSubscribeTo", items: object)
                debugPrint("Запрос к серверу на получение прогноза юнита транспорта.")
            }else{
                debugPrint("Запрос к серверу на получение прогноза юнита транспорта не отправлен.")
            }
        }
    }
    
    func configureView(transportId: String?){
        if(transportId == nil){
            return
        }
        
        model.showIndicator = true
        model.opacity = 0
        self.model.transportId = transportId!
        self.model.transportUnitDescription = "-"
        
        getTransportData()
    }
    
    func updateTransportScreen(obj: TransportResponse) {
        DispatchQueue.main.async {
            self.model.data.removeAll()
           
            var firstStationState = false
            var stationState = StationState.someStation
            obj.data.ts_stops.forEach { ts_stop in
                if(ts_stop.finish == 0){
                    stationState = .someStation
                }else{
                    if(firstStationState){
                        stationState = .endStation
                    }else{
                        stationState = .startStation
                        firstStationState = true
                    }
                }
                self.model.data.append(Station(id: ts_stop.id, name: DataBase.getStopName(stopId: ts_stop.id), stationState: stationState, pictureTs: "", time: "5 мин"))
                
            }
            
            self.model.startStation = DataBase.getStopName(stopId: obj.data.ts_stops.first?.id ?? 0)
            self.model.endStation = DataBase.getStopName(stopId: obj.data.ts_stops.last?.id ?? 0)
            
            self.model.locations.removeAll()
            
            self.model.locations.append(ShowTransportUnitModel.Location(name: "Name", icon: "bus", coordinate: CLLocationCoordinate2D(latitude: obj.data.latlng.first ?? 0, longitude: obj.data.latlng.last ?? 0)))
            
            
            self.model.maintenance = obj.data.reys_status
            
            self.model.priceCard = obj.data.price.bank_card ?? 0
            self.model.priceCash = obj.data.price.cash ?? 0
            self.model.priceTransportCard = obj.data.price.card ?? 0
            
            self.model.routeNumber = "№ \(obj.data.route)"
            
            self.model.timeWord = obj.data.time_reys
            
            let type = GeneralViewModel.getTransportTypeFromString(transport_type: obj.data.ts_type)
            
            let typeString = self.getName(type: type)
            
            self.model.transportUnitDescription = "\(typeString) \(obj.data.gosnumber)"
            
            self.showData()
            
        }
        
    }
    
    private func getName(type: TypeTransport) -> String {
        switch type {
        case .bus:
            return "АВТОБУС"
        case .train:
            return "ТРАМВАЙ"
        case .trolleybus:
            return "ТРОЛЛЕЙБУС"
        case .countrybus:
            return "АВТОБУС"
        }
    }
}
