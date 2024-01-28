//
//  FavoritesView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.02.2023.
//

import SwiftUI

struct FavoriteRoutesAndStationsView: View {
    
    @ObservedObject var model = FavoritesRoutesAndStationsModel.shared
    @ObservedObject var tabBar = AppTabBarModel.shared
    @Binding var navigationStack: NavigationPath
    
    var body: some View {
        VStack{
            LabelIzhevsk(withBackButton: false){
                
            }
            ScrollView(.vertical, showsIndicators: false){
                if model.favoriteRoutes.isEmpty && model.favoriteStops.isEmpty {
                    VStack(alignment: .center){
                        Text("Избранных нет")
                            .foregroundColor(.blue)
                            .font(.system(size: 25))
                            .kerning(2)
                            .minimumScaleFactor(0.01)
                    }
                    .frame(minHeight: UIScreen.screenHeight-250)
                    
                }else{
                    if(!model.favoriteRoutes.isEmpty){
                        HStack{
                            Text("МОИ МАРШРУТЫ")
                                .foregroundColor(.blue)
                                .font(.system(size: 25))
                                .kerning(2)
                                .padding(.leading, 20)
                                .minimumScaleFactor(0.01)
                                .offset(x: 5)
                            Spacer()
                        }
                        ForEach(model.favoriteRoutes){ item in
                            TableOfRouteWithType(typeTransport: item.type, arrayNumbers: item.numbers, handlerFunc: favoriteRouteTapped(number:type:))
                        }
                    }
                    if(!model.favoriteStops.isEmpty){
                        HStack{
                            Text("МОИ ОСТАНОВКИ")
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
                        
                        ForEach(model.favoriteStops){ item in
                            HStack{
                                StopRowView(stop: StopItem(stop_id: item.stopId, typeTransportList: [], stopName: item.stopName, stopDirection: item.stopDirection))
                                    .onTapGesture {
                                        favoriteStopTapped(stopId: item.stopId)
                                    }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                            
                        }
                    }
                }
                
                Spacer()
                
            }
        }
        .frame(width: UIScreen.screenWidth)
    }
    
    func favoriteRouteTapped(number: String, type: TypeTransport){
        TransportGroupStackManager.shared.clearNavigationStack()
        
        let routeId = DataBase.getRouteId(type: type, number: number)
        
        ShowTransportRouteViewModel.shared.configureView(routeId: routeId, type: type, number: number)
        
        navigationStack.append(CurrentTransportSelectionView.showRouteOnline)
    }
    
    func favoriteStopTapped(stopId: Int){
        TransportGroupStackManager.shared.clearNavigationStack()
        
        ShowTransportStopViewModel.shared.configureView(stop_id: stopId)
        
        navigationStack.append(CurrentTransportSelectionView.showStopOnline)
    }
    
}

//struct FavoritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteRoutesAndStationsView()
//    }
//}



