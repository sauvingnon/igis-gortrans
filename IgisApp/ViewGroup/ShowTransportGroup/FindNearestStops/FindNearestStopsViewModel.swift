//
//  FindNearestStopsViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.12.2023.
//

import Foundation
import MapKit

class FindNearestStopsViewModel {
    
    static let shared = FindNearestStopsViewModel()
    
    private init(){
        
    }
    
    private let model = FindNearestStopsModel.shared
    private var locationManager = LocationManager()
    private var mapAlreadyCenter = false
    private var value: Int = 300
    // Каждые 10 секунд обновляем список остановок относительно геопозиции
    private let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {_ in
        timerFire()
    })
    
    func setValueDiff(value: Float){
        self.value = Int(value*3000)
        self.getNearestStops()
    }
    
    func configureView(){
        debugPrint("Начат поиск ближайших остановок.")
        mapAlreadyCenter = false
        locationManager.startUpdating()
        getCurrentLocation()
        timer.fire()
    }
    
    private static func timerFire(){
        shared.getNearestStops()
        debugPrint("Список ближайших остановок обновлен.")
    }
    
    func disConfigureView(){
        locationManager.stopUpdating()
        timer.invalidate()
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
            
            var locations: [FindNearestStopsModel.Location] = []
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
                        locations.append(FindNearestStopsModel.Location(name: name, icon: "xmark.circle", coordinate: CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(lon))))
                        let typesTransport = DataBase.getTypesTransportForStop(stopId: stop.stop_id)
                        stopsList.append(StopItem(stop_id: stop.stop_id, typeTransportList: typesTransport, stopName: name, stopDirection: direction, distance: Int(resultDiffInMetters)))
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
