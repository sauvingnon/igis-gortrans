//
//  FindNearestStopsModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.12.2023.
//

import Foundation
import MapKit
import Combine

class FindNearestStopsModel: ObservableObject {
    
    static let shared = FindNearestStopsModel()
    
    private init(){
        
    }
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.843599,
            longitude: 53.202824),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1))
    
    @Published var locations: [Location] = []
    @Published var stopsList: [StopItem] = []
    
    struct Location: Identifiable{
        let id = UUID()
        let name: String
        let icon: String
        let coordinate: CLLocationCoordinate2D
    }
}
