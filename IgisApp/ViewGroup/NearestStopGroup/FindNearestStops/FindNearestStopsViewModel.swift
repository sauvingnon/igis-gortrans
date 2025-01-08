//
//  FindNearestStopsViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.12.2023.
//

import Foundation
import MapKit
import SwiftUI

class FindNearestStopsViewModel {
    
    static let shared = FindNearestStopsViewModel()
    
    private init(){
        
    }
    
    private let model = FindNearestStopsModel.shared
    private var locationManager = LocationManager.shared
    private var mapAlreadyCenter = false
    private var value: Int = 150
    // Каждые 10 секунд обновляем список остановок относительно геопозиции
    private var timer: Timer?
    var nearestValue: Int {
        get{
            return value
        }
    }
    
    func setValueDiff(value: Float){
        self.value = Int(value*3000)
//        self.getNearestStops()
    }
    
    func configureView(){
        
        locationManager.startUpdating()
        
        FireBaseService.shared.nearestStopsWasOpened()
        
        debugPrint("Начат поиск ближайших остановок.")
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {_ in
            self.timerFire()
        })
        mapAlreadyCenter = false
        getCurrentLocation()
        timer!.fire()
    }
    
    private func timerFire(){
        getNearestStops()
        debugPrint("Список ближайших остановок обновлен.")
    }
    
    func disConfigureView(){
        locationManager.stopUpdating()
        timer?.invalidate()
        debugPrint("Поиск ближайших остановок завершен.")
    }
    
    private func getCurrentLocation(){
        let queue = DispatchQueue.global(qos: .default)
        
        queue.async {
            while(!self.mapAlreadyCenter){
                if let userLocation = self.locationManager.lastLocation?.coordinate{
                    DispatchQueue.main.async {
                        self.model.region = MKCoordinateRegion(
                            center: userLocation,
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.01,
                                longitudeDelta: 0.01))
                    }
                    self.mapAlreadyCenter = true
                }
            }
            self.getNearestStops()
        }
    }
    
    private func getNearestStops(){
        if let userLocation = self.locationManager.lastLocation?.coordinate{
            
            var locations: [StopAnnotation] = []
            var stopsList: [StopItem] = []
            
            let stops = DataBase.getAllStops()
            
            stops.forEach { stop in
                let latDiff = abs(stop.stop_lat! - Float(userLocation.latitude ))
                let lonDiff = abs(stop.stop_long! - Float(userLocation.longitude ))
                let latDiffInMetters = Double(latDiff * 111000)
                let lonDiffInMetters = Double(lonDiff * 111000 * 0.5468357229)
                let resultDiffInMetters = Int(sqrt(pow(Double(lonDiffInMetters),2) + pow(Double(latDiffInMetters),2)))
                // А если использовать вот эту переменную как ограничитель?
                let summDistance = lonDiff + latDiff
                if(resultDiffInMetters < value){
                    if let name = stop.stop_name, let lon = stop.stop_long, let lat = stop.stop_lat, let direction = stop.stop_direction{
                        
                        let types = DataBase.getTypesTransportForStop(stopId: stop.stop_id)
                        
                        var color: Color = .orange
                        var letter = "A"
                        
                        if(types.contains(.train)){
                            color = .red
                            letter = "T"
                        }
                        
                        if(types.contains(.trolleybus)){
                            color = .blue
                            letter = "T"
                        }
                        
                        if(types.contains(.bus) && types.contains(.trolleybus)){
                            color = .blue
                            letter = "AT"
                        }
                        
                        locations.append(StopAnnotation(stop_id: stop.stop_id, stop_name: stop.stop_name, stop_name_short: stop.stop_name_short, color: color, stop_direction: stop.stop_direction, stop_types: types, coordinate: CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(lon)), stop_demand: stop.stop_demand, letter: letter))
                        
                        stopsList.append(StopItem(stop_id: stop.stop_id, typeTransportList: types, stopName: name, stopDirection: direction, distance: Int(resultDiffInMetters)))
                    }else{
                        debugPrint("Ошибка при получении данных из таблицы stops. id - \(stop.stop_id)")
                    }
                }
            }
            
            stopsList.sort { item_1, item_2 in
                item_1.distance! < item_2.distance!
            }
    
            
            DispatchQueue.main.async {
                self.model.locations = locations
                self.model.stopsList = stopsList
            }
            
        }
    }
    
}
