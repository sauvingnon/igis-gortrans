//
//  MapView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: 56.843599,
                        longitude: 53.202824),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.1,
                        longitudeDelta: 0.1))
                    
    var body: some View {
        MapKit.Map.init(coordinateRegion: $region)
            .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
