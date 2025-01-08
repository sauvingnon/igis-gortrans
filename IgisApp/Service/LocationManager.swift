//
//  LocationManager.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.12.2023.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    public static let shared = LocationManager()

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        requestLocationAccess()
    }
    
    func requestLocationAccess(){
        locationManager.requestWhenInUseAuthorization()
        locationStatus = locationManager.authorizationStatus
    }
    
    func startUpdating(){
        if(locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways){
            
        }else{
            requestLocationAccess()
        }
        locationManager.startUpdatingLocation()
    }

    func stopUpdating(){
        locationManager.stopUpdatingLocation()
    }
    
    var statusIsWork: Bool{
        return lastLocation != nil
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}
