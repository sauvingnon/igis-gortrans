//
//  ShowTransportUnitModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.11.2023.
//

import Foundation
import MapKit
import SwiftUI

class ShowTransportUnitModel: ObservableObject {
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.843599,
            longitude: 53.202824),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1))
    
    @Published var opacity = 1.0
    @Published var showIndicator = false
    var transportType: TypeTransport = .bus
    var transportUnitDescription = "—"
    var transportId = ""
    var data: [Stop] = []
    var priceCash = 0
    var priceCard = 0
    var priceTransportCard = 0
    var routeNumber: String?
    var startStation: String?
    var endStation: String?
    var transportModel: String?
    var timeWord: String?
    var maintenance: String?
    var currentStopId: Int = 0
    var alertAlreadyShow = false
    
    @Published var locations: [TransportAnnotation] = []
    
}
