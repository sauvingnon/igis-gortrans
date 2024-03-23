//
//  MapItem.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.02.2024.
//

import SwiftUI
import MapKit

struct MapItemSmall: View {
    
    var transportAnnotation: TransportAnnotation
    
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
                        .foregroundStyle(transportAnnotation.color)
                }
            }
            .rotationEffect(.degrees(Double(transportAnnotation.azimuth)))
        }
        .frame(width: 100, height: 100)
        .scaleEffect(0.1)
    }
}

#Preview {
    MapItemSmall(transportAnnotation: TransportAnnotation(icon: "bus", color: .green, type: .bus, finish_stop: "мкрн Нагорный", current_stop: "ул. Планерная", route: "22", ts_id: "", inPark: true, gosnumber: "М245РУ18", azimuth: 150, coordinate: CLLocationCoordinate2D(
        latitude: 56.843599,
        longitude: 53.202824)))
}

