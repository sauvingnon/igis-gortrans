//
//  FindNearestStopsModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.12.2023.
//

import Foundation
import MapKit
import Combine
import SwiftUI

class FindNearestStopsModel: ObservableObject {
    
    static let shared = FindNearestStopsModel()
    
    private init(){
        
    }
    
    @Published var lockLocation = false
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.843599,
            longitude: 53.202824),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1))
    
    @Published var locations: [StopAnnotation] = []
    @Published var stopsList: [StopItem] = []
    
}
