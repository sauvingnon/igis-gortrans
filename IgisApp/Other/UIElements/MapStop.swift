//
//  MapStop.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 22.03.2024.
//

import SwiftUI
import MapKit

struct MapStop: View {
    
    var stopAnnotation: StopAnnotation
    
    var body: some View {
        ZStack{
            Image(systemName: "mappin.square.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(stopAnnotation.color)
                .padding(3)
                .scaleEffect(0.8)
        }
        .frame(width: 100, height: 100)
        .scaleEffect(0.2)
    }
}

#Preview {
    MapStop(stopAnnotation: StopAnnotation(stop_id: 0, stop_name: "улица Леваневского", stop_name_short: "ул. Леваневского", color: .green, stop_direction: "", stop_types: [.bus], coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), stop_demand: 0))
}
