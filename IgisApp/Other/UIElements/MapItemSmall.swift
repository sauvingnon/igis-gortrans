//
//  MapItem.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.02.2024.
//

import SwiftUI
import MapKit

struct MapItemSmall: View {
    
    var location: CustomAnnotation
    
    var body: some View {
        ZStack{
            ZStack{
                ZStack{
                    Circle()
                        .foregroundStyle(.white)
                }
                .scaleEffect(1.4)
                ZStack{
                    Circle()
                        .foregroundStyle(location.color)
                }
            }
            .rotationEffect(.degrees(Double(location.azimuth)))
        }
        .frame(width: 100, height: 100)
        .scaleEffect(0.1)
    }
}

//#Preview {
//    MapItemSmall(location: LocationTransport(name: "21", icon: "bus", coordinate: CLLocationCoordinate2D(latitude: 56.0, longitude: 53.0), color: .green, type: .bus, azimuth: 0))
//}

