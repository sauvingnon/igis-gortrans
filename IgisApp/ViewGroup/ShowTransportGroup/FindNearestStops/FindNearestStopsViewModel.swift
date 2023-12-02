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
    var locationManager = LocationManager()
    var mapAlreadyCenter = false
    
    func configureView(){
        mapAlreadyCenter = false
        locationManager.startUpdating()
        getCurrentLocation()
    }
    
    func disConfigureView(){
        locationManager.stopUpdating()
    }
    
    func getCurrentLocation(){
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
    
    func getNearestStops(){
        if let userLocation = self.locationManager.lastLocation?.coordinate{
            var locations: [FindNearestStopsModel.Location] = []
            var stopsList: [StopItem] = []
            let stops = DataBase.getAllStops()
            
            stops.forEach { stop in
                let latDiff = abs(stop.stop_lat! - Float(userLocation.latitude ))
                let lonDiff = abs(stop.stop_long! - Float(userLocation.longitude ))
                if(latDiff < 0.01 && lonDiff < 0.01){
                    locations.append(FindNearestStopsModel.Location(name: stop.stop_name!, icon: "xmark.circle", coordinate: CLLocationCoordinate2D(latitude: Double(stop.stop_lat!), longitude: Double(stop.stop_long!))))
                    stopsList.append(StopItem(stop_id: stop.stop_id, typeTransportList: [], stopName: stop.stop_name!, stopDirection: stop.stop_direction!))
                    
                }
            }
            
            DispatchQueue.main.async {
                self.model.locations = locations
                self.model.stopsList = stopsList
            }
            
        }
    }
    
}
