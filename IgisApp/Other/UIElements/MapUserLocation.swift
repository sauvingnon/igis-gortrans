//
//  MapUserLocation.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 16.04.2024.
//

import SwiftUI
import MapKit

struct MapUserLocation: View {
    
    let userLocation : MKUserLocation
    
    var body: some View {
        ZStack{
            HStack{
                Image(systemName: "figure.stand")
                    .foregroundColor(.blue)
            }
        }
        .frame(width: 100, height: 100)
        .scaleEffect(1.5)
    }
}

#Preview {
    MapUserLocation(userLocation: MKUserLocation())
}
