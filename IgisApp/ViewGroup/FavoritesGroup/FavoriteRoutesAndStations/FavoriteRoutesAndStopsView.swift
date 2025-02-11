//
//  FavoritesView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.02.2023.
//

import SwiftUI

struct FavoriteRoutesAndStopsView: View {
    
    @ObservedObject var model = FavoritesRoutesAndStopsModel.shared
    @ObservedObject var tabBar = AppTabBarModel.shared
    @Binding var navigationStack: NavigationPath
    
    var body: some View {
        VStack{
            LabelIzhevsk(stack: $navigationStack){
                
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
                                StopRowView(stop: StopItem(stop_id: item.stop_id, typeTransportList: item.typeTransportList, stopName: item.stopName, stopDirection: item.stopDirection), handlerFunc: favoriteStopTapped)
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
        .onAppear(){
            FireBaseService.shared.favoritePageWasOpened()
        }
        .frame(width: UIScreen.screenWidth)
    }
    
    private func favoriteStopTapped(stop_id: Int){
        navigationStack.append(CurrentTransportSelectionView.showStopOnline(stop_id))
        
    }
    
    private func favoriteRouteTapped(number: String, type: TypeTransport){
        TransportGroupStackManager.shared.clearNavigationStack()
        
        let routeId = DataBase.getRouteId(type: type, number: number)
        
        navigationStack.append(CurrentTransportSelectionView.showRouteOnline(routeId))
    }
    
}

struct FavoritesView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        FavoriteRoutesAndStopsView(navigationStack: $stack)
    }
}



