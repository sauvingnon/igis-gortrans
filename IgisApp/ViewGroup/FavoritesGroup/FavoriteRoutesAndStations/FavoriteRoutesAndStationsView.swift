//
//  FavoritesView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.02.2023.
//

import SwiftUI

struct FavoriteRoutesAndStationsView: View {
    
    @Binding var navigationStack: [CurrentFavoritesSelectionView]
    
    @ObservedObject var model = FavoritesRoutesAndStationsModel.shared
    
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
                            SomeTransport(typeTransport: item.type, arrayNumbers: item.numbers, handlerFunc: favoriteRouteTapped(number:type:))
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
                        ForEach(model.favoriteStops){ item in
                            StopRowView(stop: StopItem(stop_id: item.stopId, typeTransportList: [], stopName: item.stopName, stopDirection: item.stopDirection))
                        }
                    }
                }
                
                Spacer()
                
            }
        }
        .frame(width: UIScreen.screenWidth)
    }
    
    func favoriteRouteTapped(number: String, type: TypeTransport){
        let routeId = DataBase.getRouteId(type: type, number: number)
        
        ShowFavoriteRouteViewModel.shared.configureView(routeId: routeId, type: type, number: number)
        
        navigationStack.append(.showFavoriteRoute)
    }
    
}

//struct FavoritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteRoutesAndStationsView()
//    }
//}



