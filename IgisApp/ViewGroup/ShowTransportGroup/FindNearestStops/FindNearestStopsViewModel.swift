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
    // Каждые 10 секунд обновляем список остановок относительно геопозиции
    private let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: {_ in
        timerFire()
    })
    
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
            var sortedStopsList: [StopItem] = []
            var stopsList: [StopItemsSorter] = []
            
            let stops = DataBase.getAllStops()
            
            stops.forEach { stop in
                let latDiff = abs(stop.stop_lat! - Float(userLocation.latitude ))
                let lonDiff = abs(stop.stop_long! - Float(userLocation.longitude ))
                let summDistance = lonDiff + latDiff
                if(latDiff < 0.005 && lonDiff < 0.005){
                    locations.append(FindNearestStopsModel.Location(name: stop.stop_name!, icon: "xmark.circle", coordinate: CLLocationCoordinate2D(latitude: Double(stop.stop_lat!), longitude: Double(stop.stop_long!))))
                    stopsList.append(StopItemsSorter(summDistance: summDistance, item: StopItem(stop_id: stop.stop_id, typeTransportList: [], stopName: stop.stop_name!, stopDirection: stop.stop_direction!)))
                    
                }
            }
            
            stopsList.sort { item1, item2 in
                item1.summDistance < item2.summDistance
            }
            
            sortedStopsList = stopsList.compactMap { item in
                item.item
            }
            
            DispatchQueue.main.async {
                self.model.locations = locations
                self.model.stopsList = sortedStopsList
            }
            
        }
    }
    
    private struct StopItemsSorter{
        let summDistance: Float
        let item: StopItem
    }
    
}
