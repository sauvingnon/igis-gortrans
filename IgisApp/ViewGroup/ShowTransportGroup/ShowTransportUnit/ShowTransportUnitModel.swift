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
    static let shared = ShowTransportUnitModel()
    private init(){
        
    }
    
    @Published var opacity = 1.0
    @Published var showIndicator = false
    @Published var transportUnitDescription = "-"
    var transportId = ""
    var data: [Station] = []
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
    
    @Published var locations: [Location] = []
    
    struct Location: Identifiable{
        let id = UUID()
        let name: String
        let icon: String
        let coordinate: CLLocationCoordinate2D
    }
}
