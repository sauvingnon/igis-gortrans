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
        
        FireBaseService.shared.mapWasOpened()
    }
    
    func centerRegionOnUserLocation(){
        
        if(LocationManager.shared.statusString == "authorizedWhenInUse" || LocationManager.shared.statusString == "authorizedAlways"){
            CustomMap.setRegionOnUserLocation()
        }else{
//            AppTabBarViewModel.shared.showAlert(title: "Уважаемый пользователь!", message: "Разрешите доступ к службам геолокации в настройках устройства.")
            AppTabBarViewModel.shared.systemShowError(message: "Разрешите доступ к службам геолокации в настройках устройства")
        }
        
    }
    
    func fillLocations(obj: EverythingResponse) -> [TransportAnnotation]{
        var locations: [TransportAnnotation] = []
        
        let favoriteRoutes = GeneralViewModel.getFavoriteRouteId()
        
        for item in obj.data {
            
            let type = GeneralViewModel.getTransportTypeFromString(transport_type: item.ts_type)
            
            if let selectedTransportAnnotation = model.selectedTransportAnnotation{
                
                let routeId = DataBase.getRouteId(type: selectedTransportAnnotation.type, number: selectedTransportAnnotation.route)
                
                let item_type = GeneralViewModel.getTransportTypeFromString(transport_type: item.ts_type)
                
                let item_routeId = DataBase.getRouteId(type: item_type, number: item.route)
                
                if(item_routeId != routeId){
                    continue;
                }
                
            }
            
            if let selectedRouteId = model.selectedRouteId{
                
                let item_type = GeneralViewModel.getTransportTypeFromString(transport_type: item.ts_type)
                
                let item_routeId = DataBase.getRouteId(type: item_type, number: item.route)
                
                if(item_routeId != selectedRouteId){
                    continue
                }
                
            }
            
            if((model.hideBus && type == .bus) || (model.hideTrain && type == .train) || (model.hideTrolleybus && type == .trolleybus) || (model.hideCountrybus && type == .countrybus)){
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
                
                let transportIcon = GeneralViewModel.getPictureTransportWhite(type: item.ts_type)
                let color = GeneralViewModel.getTransportColor(typeIgis: item.ts_type)
                
                let inPark = item.inpark == 1
                
                var currentStop = ""
                
                if(item.stop.current != nil){
                    currentStop = "Сейчас на \(DataBase.getStopName(stopId: item.stop.current!))"
                }else if(item.stop.next != nil){
                    currentStop = "Подъезжает к \(DataBase.getStopName(stopId: item.stop.next!))"
                }else{
                    currentStop = "—"
                }
                
                let finishStop = "Идет до \(DataBase.getStopFinalName(stopId: item.stop.finish.id))"

                locations.append(TransportAnnotation(icon: transportIcon, color: color, type: type, finish_stop: finishStop, current_stop: currentStop, route: item.route, ts_id: item.id, inPark: inPark, gosnumber: item.gosnumber, azimuth: item.azimuth, coordinate: CLLocationCoordinate2D(latitude: item.latlng.first!, longitude: item.latlng.last!)))
            }
        }
        
        
        return locations
    }
    
    func reloadTransportAnnotationsOnMap(){
        if let bufferResponse = self.bufferResponse{
            DispatchQueue.main.async{
                self.model.transportAnnotations = self.fillLocations(obj: bufferResponse)
            }
        }
    }
    
    func showAlert(title: String, message: String){
        
    }
    
    func showAlertBadResponse(){
        if(model.alertAlreadyShow){
            return
        }
        DispatchQueue.main.async {
            self.showAlert(title: "Нет сведений о транспорте на карте", message: "Нет данных")
            self.model.alertAlreadyShow = true
        }
    }
    
    func updateMapScreen(data: Data){
        
        guard let obj = try? MessagePackDecoder().decode(EverythingResponse.self, from: data)else {
            debugPrint("Ошибка при декодировании объекта EverythingResponse \(Date.now)")
            showAlertBadResponse()
            return
        }
        
        debugPrint("были получены данные о всем транспорте на карте \(Date.now)")
        
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
                ServiceSocket.shared.emitOn(event: "cliSerSubscribeTo", items: object, callback: self.updateMapScreen)
                debugPrint("Запрос к серверу на получение прогноза всего транспорта.")
            }else{
                debugPrint("Запрос к серверу на получение прогноза всего транспорта не отправлен.")
            }
        }
    }
    
    func selectStopAnnotation(stopAnnotation: StopAnnotation, showOnlyOneAnnotation: Bool = false){
        
        if(showOnlyOneAnnotation){
            CustomMap.removeStopsAnnotation(stopAnnotations: model.stopAnnotations)
            CustomMap.appendStopsAnnotation(stopAnnotations: [stopAnnotation])
        }
        MapModel.shared.selectedStopAnnotation = stopAnnotation
        MapModel.shared.selectedTransportAnnotation = nil
        CustomMap.setRegion(region: MKCoordinateRegion(center: stopAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)))
        
        if(MapModel.shared.sheetIsPresented){
            withAnimation(.default, {
                MapModel.shared.mainText = stopAnnotation.stop_name ?? ""
                MapModel.shared.secondText = stopAnnotation.stop_direction ?? ""
                MapModel.shared.thirdText = MapViewModel.shared.getStringOfTypesTransport(types: stopAnnotation.stop_types)
            })
        }else{
            MapModel.shared.mainText = stopAnnotation.stop_name ?? ""
            MapModel.shared.secondText = stopAnnotation.stop_direction ?? ""
            MapModel.shared.thirdText = MapViewModel.shared.getStringOfTypesTransport(types: stopAnnotation.stop_types)
            MapModel.shared.sheetIsPresented = true
        }
    }
    
    // Показать маршрут на карте
    func selectRoute(routeId: Int){
        MapModel.shared.selectedStopAnnotation = nil
        MapModel.shared.selectedTransportAnnotation = nil
        
        // Центровка карты примерно в центре города
        CustomMap.setRegion(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56.843599, longitude: 53.202824), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
        
        showRoute(routeId: routeId)
        
        let routeNumber = DataBase.getRouteNumber(routeId: routeId)
        let type = DataBase.getTypeTransportFromId(routeId: routeId)
        let name = GeneralViewModel.getName(type: type, number: routeNumber)
        
        if(MapModel.shared.sheetIsPresented){
            withAnimation(.default, {
                MapModel.shared.mainText = name
                MapModel.shared.secondText = ""
                MapModel.shared.thirdText = ""
                MapModel.shared.selectedRouteId = routeId
            })
        }else{
            MapModel.shared.mainText = name
            MapModel.shared.secondText = ""
            MapModel.shared.thirdText = ""
            MapModel.shared.selectedRouteId = routeId
            MapModel.shared.sheetIsPresented = true
        }
        
        reloadTransportAnnotationsOnMap()

    }
    
    // Отображение ломанной маршрута
    func showRoute(routeId: Int){
        // Получение и отрисовка остановок этого маршрута на карте
        CustomMap.removeStopsAnnotation(stopAnnotations: MapModel.shared.stopAnnotations)
        
        let stops = DataBase.getStopsOfRoute(routeId: routeId)
        
        let filterStopAnnotations = MapModel.shared.stopAnnotations.filter { annotation in
            stops.contains(annotation.stop_id)
        }
        
        CustomMap.appendStopsAnnotation(stopAnnotations: filterStopAnnotations)
        
        // Получение и отрисовка перегонов этого маршрута на карте
        let stagesList = DataBase.getStagesForRoute(route_id: routeId)
        
        // Перебор каждой линии перегонов
        stagesList.forEach { routeLine in
            
            // Сборка точек для всей линии
            var points = [CLLocationCoordinate2D]()
            
            // В каждой линии отдельный линия-перегон
            routeLine.forEach { stage in
                
                let point = stage.stage_coords.map { lonLat in
                    return CLLocationCoordinate2D(latitude: Double(lonLat[0]), longitude: Double(lonLat[1]))
                }
                
                points.append(contentsOf: point)
                
            }
            
            CustomMap.appendLines(points: points)
            
        }
        // На выходе надо цельную линию из всех линий по порядку
    }
    
    // Отображение юнита транспорта на карте и ломанной его маршрута
    func selectTransportAnnotation(transportAnnotation: TransportAnnotation){
        MapModel.shared.selectedStopAnnotation = nil
        MapModel.shared.selectedTransportAnnotation = transportAnnotation
        CustomMap.setRegion(region: MKCoordinateRegion(center: transportAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)))
        
        let routeId = DataBase.getRouteId(type: transportAnnotation.type, number: transportAnnotation.route)
        showRoute(routeId: routeId)
        
        if(MapModel.shared.sheetIsPresented){
            withAnimation(.default, {
                MapModel.shared.mainText = GeneralViewModel.getName(type: transportAnnotation.type, number: transportAnnotation.route)
                MapModel.shared.secondText = transportAnnotation.current_stop
                MapModel.shared.thirdText = transportAnnotation.finish_stop
            })
        }else{
            MapModel.shared.mainText = GeneralViewModel.getName(type: transportAnnotation.type, number: transportAnnotation.route)
            MapModel.shared.secondText = transportAnnotation.current_stop
            MapModel.shared.thirdText = transportAnnotation.finish_stop
            MapModel.shared.sheetIsPresented = true
        }
        
        reloadTransportAnnotationsOnMap()
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
