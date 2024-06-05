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
            HStack{
                Text(stopAnnotation.letter)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
            .frame(width: 50, height: 50)
            .background(stopAnnotation.color)
            .cornerRadius(10.0)
        }
        .frame(width: 100, height: 100)
        .scaleEffect(0.4)
    }
}

#Preview {
    MapStop(stopAnnotation: StopAnnotation(stop_id: 0, stop_name: "улица Леваневского", stop_name_short: "ул. Леваневского", color: .blue, stop_direction: "", stop_types: [.bus, .trolleybus], coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), stop_demand: 0, letter: "AT"))
}
