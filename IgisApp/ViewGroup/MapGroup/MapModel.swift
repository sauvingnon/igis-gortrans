//
//  MapModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 31.05.2023.
//

import Foundation
import MapKit

class MapModel: ObservableObject{
    @Published var locations: [Location] = []
    
    struct Location: Identifiable{
        let id = UUID()
        let name: String
        let icon: String
        let coordinate: CLLocationCoordinate2D
    }
}
