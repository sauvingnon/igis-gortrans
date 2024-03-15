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
    
    var body: some View {
        ZStack{
            CustomMap()
                .ignoresSafeArea()
                .overlay{
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
                        Button(action: {
                            model.onlyFavoritesTransport.toggle()
                            viewModel.reloadMap()
                        }, label: {
                            Image(systemName: model.onlyFavoritesTransport ? "star.fill" : "star")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.white)
                                .padding(3)
                                .background(.green)
                                .cornerRadius(10)
                        })
                        .padding(10)
                    }
                    .frame(width: 50, height: 240)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(20)
                    .position(x: UIScreen.screenWidth-30, y: UIScreen.screenHeight/2)
                }
            
            DropDownAlert(isPresent: $model.sheetIsPresented)
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
