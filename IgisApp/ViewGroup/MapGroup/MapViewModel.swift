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

class MapViewModel {
    
    static let shared = MapViewModel()
    
    private init(){
        
    }
    
    private var model = MapModel.shared
    private var bufferResponse: EverythingResponse?
    
    func getTransportCoordinate(){
        self.getEverythingData(city: "izh")
    }
    
    func fillLocations(obj: EverythingResponse) -> [MapModel.Location]{
        var locations: [MapModel.Location] = []
        
        for item in obj.data {
            
            let type = GeneralViewModel.getTransportTypeFromString(transport_type: item.ts_type)
            
            if((model.hideBus && (type == .bus || type == .countrybus)) || (model.hideTrain && type == .train) || (model.hideTrolleybus && type == .trolleybus)){
                continue
            }
            
            if(item.visible == 1 && item.reys_status == "ok"){
                
                let transportIcon = GeneralViewModel.getPictureTransport(type: item.ts_type)
                let color = GeneralViewModel.getTransportColor(type: item.ts_type)
                
                locations.append(MapModel.Location(name: item.route, icon: transportIcon, coordinate: CLLocationCoordinate2D(latitude: item.latlng.first!, longitude: item.latlng.last!), color: color, type: type))
            }
        }
        
        
        return locations
    }
    
    func reloadMap(){
        if let bufferResponse = self.bufferResponse{
            self.model.locations = fillLocations(obj: bufferResponse)
        }
    }
    
    func updateMapScreen(obj: EverythingResponse){
        
        self.bufferResponse = obj
        
        let result = fillLocations(obj: obj)
        
        DispatchQueue.main.async {
            self.model.locations = result
        }
        debugPrint("карта была обновлена")
    }
    
    func getEverythingData(city: String){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
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
