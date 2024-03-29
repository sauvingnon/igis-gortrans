//
//  FindNearestStops.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.12.2023.
//

import SwiftUI
import MapKit

struct FindNearestStopsView: View {
    
    @Binding var navigationStack: NavigationPath
    
    @State var mode = MapUserTrackingMode.follow
    
    @ObservedObject private var model = FindNearestStopsModel.shared
    private let viewModel = FindNearestStopsViewModel.shared
    
    var columns: [GridItem] = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            LabelIzhevsk(stack: $navigationStack){
                
            }
            
            ScrollView{
                Map(coordinateRegion: $model.region, showsUserLocation: true, userTrackingMode: $mode, annotationItems: model.locations){
                    location in
                    MapAnnotation(coordinate: location.coordinate){
                        Button(action: {
                            AppTabBarViewModel.shared.showAlert(title: "Показать остановку", message: location.stop_name ?? "-")
                        }, label: {
                            MapStop(stopAnnotation: StopAnnotation(stop_id: location.stop_id, stop_name: location.stop_name, stop_name_short: location.stop_name_short, color: location.color, stop_direction: location.stop_direction, stop_types: location.stop_types, coordinate: location.coordinate, stop_demand: location.stop_demand))
                        })
                    }
                }
                .frame(width: UIScreen.screenWidth-40, height: UIScreen.screenWidth-40)
                .cornerRadius(30)
                .padding(.bottom, 20)
                
                HStack{
                    Text("Ближайшие остановки")
                        .foregroundColor(.blue)
                        .font(.system(size: 25))
                        .kerning(2)
                        .padding(.leading, 20)
                        .minimumScaleFactor(0.01)
                        .offset(x: 5)
                    Spacer()
                }
                
                GeometryReader{ geometry in
                    
                }
                .frame(height: 2)
                .background(Color.blue)
                .padding(.horizontal, 20)
                
                LazyVGrid(columns: columns, alignment: .leading){
                    ForEach(model.stopsList) { item in
                        GridRow{
                            StopRowView(stop: item, handlerFunc: stopTapped)
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                    }
                }
                
            }
            
            Spacer()
        }
        .onAppear(){
            viewModel.configureView()
        }
        .onDisappear(){
            viewModel.disConfigureView()
        }
    }
    
    private func stopTapped(stop_id: Int){
        ShowTransportStopViewModel.shared.configureView(stop_id: stop_id)
        navigationStack.append(CurrentTransportSelectionView.showStopOnline)
    }
}

struct FindNearestStops_Preview: PreviewProvider {
    
    @State static var stack = NavigationPath([CurrentTransportSelectionView]())
    
    static var previews: some View {
        FindNearestStopsView(navigationStack: $stack)
    }
    
}
