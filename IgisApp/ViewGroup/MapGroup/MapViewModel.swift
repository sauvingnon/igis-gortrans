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
    
    func mapWasMove(){
        counter = 0
        if(self.model.locations.count != 0){
            self.model.locations = []
            print("локации очищены")
            startThread()
        }
    }
    
    func startThread(){
        if(flagTrue){
            return
        }
        flagTrue = true
        let queue = DispatchQueue.global()
        queue.async {
            while(true){
                Thread.sleep(forTimeInterval: 0.1)
                self.counter += 1
                if(self.counter == 5){
                    self.reloadMap()
                    self.flagTrue = false
                    break
                }
            }
        }
        queue.activate()
    }
    
    func mapCenterWasChanged(center: CLLocationCoordinate2D){
        mapWasMove()
    }
    
    func mapSpanWasChanged(mapSpan: MKCoordinateSpan){
        // Если карта отдалена больше чем наши пороговые значения - надо изменить иконки
        mapWasMove()
        if(mapSpan.longitudeDelta > 0.07 || mapSpan.latitudeDelta > 0.07){
            model.useSmallMapItems = true
        }else{
            model.useSmallMapItems = false
        }
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
                
//                locations.append(CustomAnnotation(name: item.route, icon: transportIcon, coordinate: CLLocationCoordinate2D(latitude: item.latlng.first!, longitude: item.latlng.last!), color: color, type: type, azimuth: item.azimuth))
                locations.append(CustomAnnotation(name: item.route, icon: transportIcon, color: color, type: type, azimuth: item.azimuth, coordinate: CLLocationCoordinate2D(latitude: item.latlng.first!, longitude: item.latlng.last!)))
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
