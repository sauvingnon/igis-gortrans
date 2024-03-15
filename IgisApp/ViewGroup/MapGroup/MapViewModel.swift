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
    private var counter = 0
    private var flagTrue = false
    
    func getTransportCoordinate(){
        self.getEverythingData(city: "izh")
    }
    
    func fillLocations(obj: EverythingResponse) -> [CustomAnnotation]{
        var locations: [CustomAnnotation] = []
        
        let favoriteRoutes = GeneralViewModel.getFavoriteRouteId()
        
        for item in obj.data {
            
            let type = GeneralViewModel.getTransportTypeFromString(transport_type: item.ts_type)
            
            if((model.hideBus && (type == .bus || type == .countrybus)) || (model.hideTrain && type == .train) || (model.hideTrolleybus && type == .trolleybus)){
                continue
            }
            
            if(model.onlyFavoritesTransport){
                
                let routeId = DataBase.getRouteId(type: type, number: item.route)
                
                if(!favoriteRoutes.contains(where: { value in
                    value == routeId
                })){
                    continue
                }
            }
            
            if(item.visible == 1 && item.reys_status == "ok"){
                
                let transportIcon = GeneralViewModel.getPictureTransport(type: item.ts_type)
                let color = GeneralViewModel.getTransportColor(type: item.ts_type)
                
                locations.append(CustomAnnotation(icon: transportIcon, color: color, type: type, route: item.route, ts_id: item.id, gosnumber: item.gosnumber, azimuth: item.azimuth, coordinate: CLLocationCoordinate2D(latitude: item.latlng.first!, longitude: item.latlng.last!)))
            }
        }
        
        
        return locations
    }
    
    func reloadMap(){
        if let bufferResponse = self.bufferResponse{
            DispatchQueue.main.async{
                self.model.locations = self.fillLocations(obj: bufferResponse)
            }
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
