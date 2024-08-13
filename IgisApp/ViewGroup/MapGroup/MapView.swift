//
//  MapView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Binding var navigationStack: NavigationPath
    
    var viewModel = MapViewModel.shared
    @ObservedObject var model = MapModel.shared
    
    var body: some View {
        ZStack{
            CustomMap()
                .ignoresSafeArea()
                .overlay{
                    ZStack{
                        VStack{
                            Button(action: {
                                model.hideBus.toggle()
                                viewModel.reloadTransportAnnotationsOnMap()
                            }, label: {
                                Image("bus_icon_white")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                    .padding(3)
                                    .background(GeneralViewModel.getTransportColor(type: .bus))
                                    .cornerRadius(10)
                                    .opacity((model.hideBus) ? 0.5 : 1.0)
                            })
                            .padding(10)
                            Button(action: {
                                model.hideTrain.toggle()
                                viewModel.reloadTransportAnnotationsOnMap()
                            }, label: {
                                Image("train_icon_white")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                    .padding(3)
                                    .background(GeneralViewModel.getTransportColor(type: .train))
                                    .cornerRadius(10)
                                    .opacity((model.hideTrain) ? 0.5 : 1.0)
                            })
                            .padding(10)
                            Button(action: {
                                model.hideTrolleybus.toggle()
                                viewModel.reloadTransportAnnotationsOnMap()
                            }, label: {
                                Image("trolleybus_icon_white")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                    .padding(3)
                                    .background(GeneralViewModel.getTransportColor(type: .trolleybus))
                                    .cornerRadius(10)
                                    .opacity((model.hideTrolleybus) ? 0.5 : 1.0)
                            })
                            .padding(10)
                            Button(action: {
                                model.hideCountrybus.toggle()
                                viewModel.reloadTransportAnnotationsOnMap()
                            }, label: {
                                Image("bus_icon_white")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                    .padding(3)
                                    .background(GeneralViewModel.getTransportColor(type: .countrybus))
                                    .cornerRadius(10)
                                    .opacity((model.hideCountrybus) ? 0.5 : 1.0)
                            })
                            .padding(10)
                            Button(action: {
                                model.onlyFavoritesTransport.toggle()
                                viewModel.reloadTransportAnnotationsOnMap()
                            }, label: {
                                Image(systemName: model.onlyFavoritesTransport ? "star.fill" : "star")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.yellow)
                                    .padding(3)
                                    .background(.white)
                                    .cornerRadius(10)
                            })
                            .padding(10)
                        }
                        .frame(width: 50, height: 280)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(20)
                        .position(x: UIScreen.screenWidth-30, y: UIScreen.screenHeight/2-100)
                        Button(action: {
                            viewModel.centerRegionOnUserLocation()
                        }, label: {
                            Image(systemName: "location.fill")
                                .padding(10)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(50)
                        })
                        .position(x: UIScreen.screenWidth-30, y: UIScreen.screenHeight/2-275)
                    }
                }
            
            DropDownAlert(isPresent: $model.sheetIsPresented, tapUnit: {
                if let transportAnnotation = model.selectedTransportAnnotation{
                    navigationStack.append(CurrentTransportSelectionView.showTransportUnit(transportAnnotation.ts_id))
                }
                
                if let stopAnnotation = model.selectedStopAnnotation{
                    navigationStack.append(CurrentTransportSelectionView.showStopOnline(stopAnnotation.stop_id))
                }
                
            }, tapRoute: {
                if let annotation = model.selectedTransportAnnotation{
                    let route_id = DataBase.getRouteId(type: annotation.type, number: annotation.route)
                    navigationStack.append(CurrentTransportSelectionView.showRouteOnline(route_id))
                }
            })
        }
        .onAppear{
            viewModel.getTransportCoordinate()
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    
    @State static var path = NavigationPath()
    
    static var previews: some View {
        MapView(navigationStack: $path)
    }
}
