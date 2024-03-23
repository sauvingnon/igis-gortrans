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
    
    func centerRegionOnUserLocation(){
        CustomMap.setRegionOnUserLocation()
    }
    
    func fillLocations(obj: EverythingResponse) -> [TransportAnnotation]{
        var locations: [TransportAnnotation] = []
        
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
                
                let inPark = item.inpark == 1
                
                var currentStop = ""
                
                if(item.stop.current != nil){
                    currentStop = "Сейчас на \(DataBase.getStopName(stopId: item.stop.current!))"
                }else if(item.stop.next != nil){
                    currentStop = "В пути к \(DataBase.getStopName(stopId: item.stop.next!))"
                }else{
                    currentStop = "—"
                }
                
                let finishStop = "Транспорт движется до \(DataBase.getStopFinalName(stopId: item.stop.finish.id))"

                locations.append(TransportAnnotation(icon: transportIcon, color: color, type: type, finish_stop: finishStop, current_stop: currentStop, route: item.route, ts_id: item.id, inPark: inPark, gosnumber: item.gosnumber, azimuth: item.azimuth, coordinate: CLLocationCoordinate2D(latitude: item.latlng.first!, longitude: item.latlng.last!)))
            }
        }
        
        
        return locations
    }
    
    func reloadMap(){
        if let bufferResponse = self.bufferResponse{
            DispatchQueue.main.async{
                self.model.transportAnnotations = self.fillLocations(obj: bufferResponse)
            }
        }
    }
    
    func updateMapScreen(obj: EverythingResponse){
        
        self.bufferResponse = obj
        
        let result = fillLocations(obj: obj)
        
        DispatchQueue.main.async {
            self.model.transportAnnotations = result
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
    
    func getStringOfTypesTransport(types: [TypeTransport]) -> String{
        if(types.isEmpty){
            return "Данных о транспорте нет"
        }
        
        var result = "Остановка "
        
        if(types.contains(where: { type in
            type == .bus
        })){
            result.append("автобуса, ")
        }
        
        if(types.contains(where: { type in
            type == .countrybus
        })){
            result.append("пригородного автобуса, ")
        }
        
        if(types.contains(where: { type in
            type == .train
        })){
            result.append("трамвая, ")
        }
        
        if(types.contains(where: { type in
            type == .trolleybus
        })){
            result.append("троллейбуса, ")
        }
        
        result.removeLast(2)
        result.append(".")
        
        return result
    }
    
    func clearMapView(){
//        DispatchQueue.main.async {
//            self.configurationMap?.locations.removeAll()
//        }
    }
}
