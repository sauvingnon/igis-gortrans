//
//  MapViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 31.05.2023.
//

import Foundation
import SwiftUI
import MapKit
import MessagePacker

class MapViewModel{
    
    static let shared = MapViewModel()
    
    private init(){
        
    }
    
    var model = MapModel()
    
    func getTransportCoordinate(){
        self.getEverythingData(city: "izh")
    }
    
    func updateMapScreen(obj: EverythingResponse){
        var bufferLocations: [MapModel.Location] = []
        obj.data.forEach { item in
            if(item.visible == 1 && item.reys_status == "ok"){
                bufferLocations.append(MapModel.Location(name: item.gosnumber, icon: GeneralViewModel.getPictureTransport(type: item.ts_type), coordinate: CLLocationCoordinate2D(latitude: item.latlng.first!, longitude: item.latlng.last!)))
            }
        }
        DispatchQueue.main.async {
            self.model.locations = bufferLocations
        }
        debugPrint("map was updated")
    }
    
    func getEverythingData(city: String){
        let queue = DispatchQueue.global(qos: .default)
        queue.sync {
            self.clearMapView()
            while(ServiceSocket.status != .connected){
                
            }
            if let object = try? MessagePackEncoder().encode(EverythingRequest(city: "izh")){
                ServiceSocket.shared.emitOn(event: "cliSerSubscribeTo", items: object)
                debugPrint("Запрос к серверу на получение прогноза всего транспорта.")
            }else{
                debugPrint("Запрос к серверу на получение прогноза всего транспорта не отправлен.")
            }
        }
    }
    
    func clearMapView(){
//        DispatchQueue.main.async {
//            self.configurationMap?.locations.removeAll()
//        }
    }
}
