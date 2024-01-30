//
//  MapView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    private var viewModel = MapViewModel.shared
    @ObservedObject private var model = MapModel.shared
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.843599,
            longitude: 53.202824),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1))
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $region, annotationItems: model.locations){ location in
                MapAnnotation(coordinate: location.coordinate){
                    ZStack{
                        Image(systemName: location.icon)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .padding(3)
                            .background(location.color)
                            .cornerRadius(50)
                        Text(location.name)
                            .padding(.horizontal, 10)
                            .background(.white)
                            .cornerRadius(10)
                            .position(x: 30, y: 30)
                            .font(.system(size: 14))
                    }
                }
                
            }
            .ignoresSafeArea()
            
            VStack{
                Button(action: {
                    model.hideBus.toggle()
                    viewModel.reloadMap()
                }, label: {
                    Image(systemName: "bus")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.white)
                        .padding(3)
                        .background(.green)
                        .cornerRadius(10)
                        .opacity((model.hideBus) ? 0.5 : 1.0)
                })
                .padding(10)
                Button(action: {
                    model.hideTrain.toggle()
                    viewModel.reloadMap()
                }, label: {
                    Image(systemName: "tram")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.white)
                        .padding(3)
                        .background(.red)
                        .cornerRadius(10)
                        .opacity((model.hideTrain) ? 0.5 : 1.0)
                })
                .padding(10)
                Button(action: {
                    model.hideTrolleybus.toggle()
                    viewModel.reloadMap()
                }, label: {
                    Image(systemName: "bus.doubledecker")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.white)
                        .padding(3)
                        .background(.blue)
                        .cornerRadius(10)
                        .opacity((model.hideTrolleybus) ? 0.5 : 1.0)
                })
                .padding(10)
            }
            .frame(width: 50, height: 200)
            .background(Color.white.opacity(0.7))
            .cornerRadius(20)
            .position(x: UIScreen.screenWidth-30, y: UIScreen.screenHeight-270)
        }
        .onAppear{
            viewModel.getTransportCoordinate()
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
