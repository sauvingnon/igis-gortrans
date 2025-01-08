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

class ShowTransportUnitViewModel: ObservableObject{

    @Published var model = ShowTransportUnitModel()
    
    func showData(){
        self.model.showIndicator = false
        withAnimation{
            self.model.opacity = 1
        }
        self.objectWillChange.send()
    }
    
    func eraseCallBack(){
        
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
                ServiceSocket.shared.emitOn(event: "cliSerSubscribeTo", items: object, callback: self.updateTransportScreen)
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
        self.model.transportUnitDescription = "—"
    }
    
    func showAlertBadResponse(){
        if(model.alertAlreadyShow){
            return
        }
        DispatchQueue.main.async {
            AppTabBarViewModel.shared.showAlert(title: "Нет сведений о данном транспортном средстве", message: "Нет данных")
            self.model.alertAlreadyShow = true
        }
    }
    
    func updateTransportScreen(data: Data) {
        
        guard let obj = try? MessagePackDecoder().decode(TransportResponse.self, from: data)else {
            debugPrint("Ошибка при декодировании объекта TransportResponse \(Date.now)")
            if(model.showIndicator){
                showAlertBadResponse()
            }
            return
        }
        
        debugPrint("был получен прогноз транспорта \(Date.now)")
        
        
        self.model.data.removeAll()
       
        var firstStationState = false
        var stationState = StationState.someStation
        var counter = 1
        
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
            self.model.data.append(Stop(id: ts_stop.id, name: DataBase.getStopName(stopId: ts_stop.id), stationState: stationState, pictureTs: "", time: "-", withArrow: (counter % 4 == 0)))
            
            counter += 1
            
        }
        
        self.model.startStation = DataBase.getStopName(stopId: obj.data.ts_stops.first?.id ?? 0)
        self.model.endStation = DataBase.getStopName(stopId: obj.data.ts_stops.last?.id ?? 0)
        
        self.model.locations.removeAll()
        
        let transportIcon = GeneralViewModel.getPictureTransportWhite(type: obj.data.ts_type)
        let color = GeneralViewModel.getTransportColor(typeIgis: obj.data.ts_type)
        let coordinate = CLLocationCoordinate2D(latitude: obj.data.latlng.first ?? 0, longitude: obj.data.latlng.last ?? 0)
        
        self.model.locations.append(TransportAnnotation(icon: transportIcon, color: color, type: GeneralViewModel.getTransportTypeFromString(transport_type: obj.data.ts_type), finish_stop: "", current_stop: "", route: obj.data.route, ts_id: "", inPark: false, gosnumber: obj.data.gosnumber, azimuth: obj.data.azimuth, coordinate: coordinate))
        
        self.model.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.model.maintenance = obj.data.reys_status
        
        self.model.priceCard = obj.data.price.bank_card ?? 0
        self.model.priceCash = obj.data.price.cash ?? 0
        self.model.priceTransportCard = obj.data.price.card ?? 0
        
        if(!obj.data.route.isEmpty){
            if(obj.data.route.first!.isNumber){
                self.model.routeNumber = "№ \(obj.data.route)"
            }else{
                self.model.routeNumber = "\(obj.data.route)"
            }
        }else{
            self.model.routeNumber = "—"
        }
        
        self.model.timeWord = obj.data.time_reys
        
        let type = GeneralViewModel.getTransportTypeFromString(transport_type: obj.data.ts_type)
        
        self.model.transportType = type
        
        let typeString = self.getName(type: type)
        
        if(!obj.data.gosnumber.isEmpty){
            if(obj.data.gosnumber.first!.isLetter){
                self.model.transportUnitDescription = "\(typeString) \(obj.data.gosnumber)"
            }else{
                self.model.transportUnitDescription = "\(typeString) №\(obj.data.gosnumber)"
            }
        }else{
            self.model.transportUnitDescription = "\(typeString)"
        }
        
        FireBaseService.shared.showUnitViewOpened(name: self.model.transportUnitDescription)
        
        self.showData()
        
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
