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
    
    @Environment(\.openURL) private var openURL
    
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
                            stopTapped(stop_id: location.stop_id)
                        }, label: {
                            MapStop(stopAnnotation: StopAnnotation(stop_id: location.stop_id, stop_name: location.stop_name, stop_name_short: location.stop_name_short, color: location.color, stop_direction: location.stop_direction, stop_types: location.stop_types, coordinate: location.coordinate, stop_demand: location.stop_demand, letter: location.letter, priority: 0))
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
                
                
                if(LocationManager.shared.statusString != "authorizedWhenInUse" && LocationManager.shared.statusString != "authorizedAlways"){
                    VStack{
                        Spacer()
                        Text("Разрешите доступ приложения к службам геолокации в настройках устройства")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                            .padding(.horizontal, 20)
                            .minimumScaleFactor(0.01)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            let settingsString = UIApplication.openSettingsURLString
                            if let settingsURL = URL (string: settingsString) {
                                openURL(settingsURL)
                            }
                        }){
                            Text("Открыть настройки")
                                .fontWeight(.light)
                                .font(.system(size: 18))
                                .kerning(0.7)
                                .padding(8)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(15)
                        }
                        
                        Spacer()
                    }
                    
                }else{
                    if(model.stopsList.count == 0){
                        VStack{
                            Spacer()
                            Text("Ближайших остановок в радиусе \(viewModel.nearestValue) м. не найдено. Измените радиус поиска в настройках приложения.")
                                .foregroundColor(.blue)
                                .font(.system(size: 20))
                                .padding(.horizontal, 20)
                                .minimumScaleFactor(0.01)
                                .multilineTextAlignment(.center)
                            Button(action: {
                                AppTabBarViewModel.shared.showPage(tab: .settings)
                            }, label: {
                                Text("Открыть настройки")
                                    .fontWeight(.light)
                                    .font(.system(size: 18))
                                    .kerning(0.7)
                                    .padding(8)
                                    .foregroundStyle(.white)
                                    .background(.blue)
                                    .cornerRadius(15)
                            })
                            Spacer()
                        }
                    }else{
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
        navigationStack.append(CurrentTransportSelectionView.showStopOnline(stop_id))
    }
}

struct FindNearestStops_Preview: PreviewProvider {
    
    @State static var stack = NavigationPath([CurrentTransportSelectionView]())
    
    static var previews: some View {
        FindNearestStopsView(navigationStack: $stack)
    }
    
}
