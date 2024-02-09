//
//  MapModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 31.05.2023.
//

import Foundation
import MapKit
import SwiftUI

class MapModel: ObservableObject{
    
    public static let shared = MapModel()
    
    private init(){
        
    }
    
    @Published var locations: [LocationTransport] = []
    @Published var hideBus = false
    @Published var hideTrain = false
    @Published var hideTrolleybus = false
    @Published var useSmallMapItems = false
    @Published var onlyFavoritesTransport = false
}

struct LocationTransport: Identifiable{
    let id = UUID()
    let name: String
    let icon: String
    let coordinate: CLLocationCoordinate2D
    let color: Color
    let type: TypeTransport
    let azimuth: Int
}
