//
//  TransportAnnotation.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 22.07.2024.
//

import Foundation
import MapKit
import SwiftUI

class TransportAnnotation: NSObject, MKAnnotation, Identifiable, CustomAnnotation {
    var priority: Int
    let id = UUID()
    let icon: String
    let color: Color
    let type: TypeTransport
    let finish_stop: String
    let current_stop: String
    let route: String
    let ts_id: String
    let inPark: Bool
    let gosnumber: String
    let azimuth: Int
    let coordinate: CLLocationCoordinate2D
    init(icon: String, color: Color, type: TypeTransport, finish_stop: String, current_stop: String, route: String, ts_id: String, inPark: Bool, gosnumber: String, azimuth: Int, coordinate: CLLocationCoordinate2D, priority: Int = 1) {
        self.icon = icon
        self.color = color
        self.type = type
        self.finish_stop = finish_stop
        self.current_stop = current_stop
        self.route = route
        self.ts_id = ts_id
        self.inPark = inPark
        self.gosnumber = gosnumber
        self.azimuth = azimuth
        self.coordinate = coordinate
        self.priority = priority
    }
}
