//
//  StopAnnotation.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 22.07.2024.
//

import Foundation
import MapKit
import SwiftUI

class StopAnnotation: NSObject, MKAnnotation, Identifiable {
    let id = UUID()
    let letter: String
    let stop_id: Int
    let stop_name: String?
    let stop_name_short: String?
    let color: Color
    let stop_direction: String?
    let stop_types: [TypeTransport]
    let coordinate: CLLocationCoordinate2D
    let stop_demand: Int?
    
    init(stop_id: Int, stop_name: String?, stop_name_short: String?, color: Color, stop_direction: String?, stop_types: [TypeTransport], coordinate: CLLocationCoordinate2D, stop_demand: Int?, letter: String) {
        self.stop_id = stop_id
        self.stop_name = stop_name
        self.stop_name_short = stop_name_short
        self.color = color
        self.stop_direction = stop_direction
        self.stop_types = stop_types
        self.coordinate = coordinate
        self.stop_demand = stop_demand
        self.letter = letter
    }
}
