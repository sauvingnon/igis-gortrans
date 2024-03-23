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
                    
                    Button(action: {
                        viewModel.centerRegionOnUserLocation()
                    }, label: {
                        Image(systemName: "location.fill")
                            .padding(10)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(50)
                            .position(x: UIScreen.screenWidth-30, y: UIScreen.screenHeight/2-250)
                    })
                    
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
                    .position(x: UIScreen.screenWidth-30, y: UIScreen.screenHeight/2-100)
                }
            
            DropDownAlert(isPresent: $model.sheetIsPresented, tapUnit: {
                if let transportAnnotation = model.selectedTransportAnnotation{
                    ShowTransportUnitViewModel.shared.configureView(transportId: transportAnnotation.ts_id)
                    navigationStack.append(CurrentTransportSelectionView.showTransportUnit)
                }
                
                if let stopAnnotation = model.selectedStopAnnotation{
                    ShowTransportStopViewModel.shared.configureView(stop_id: stopAnnotation.stop_id)
                    navigationStack.append(CurrentTransportSelectionView.showStopOnline)
                }
                
            }, tapRoute: {
                if let annotation = model.selectedTransportAnnotation{
                    let route_id = DataBase.getRouteId(type: annotation.type, number: annotation.route)
                    ShowTransportRouteViewModel.shared.configureView(routeId: route_id, type: annotation.type, number: annotation.route)
                    navigationStack.append(CurrentTransportSelectionView.showRouteOnline)
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
