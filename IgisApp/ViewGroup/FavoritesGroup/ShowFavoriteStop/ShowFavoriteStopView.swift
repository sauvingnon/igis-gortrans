//
//  FavoriteStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.02.2023.
//

import SwiftUI

struct ShowFavoriteStopView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentFavoritesSelectionView]
    
    @ObservedObject var model = ShowFavoriteStopModel.shared
    private let viewModel = ShowFavoriteStopViewModel.shared
    
    @State private var sizeStar = 1.0
    
    var body: some View {
        VStack{
            LabelOfStopOrRoute(name: model.name, isFavorite: $model.isFavorite, backTapp: {
                dismiss()
            }, starTapp: {
                viewModel.favoriteStopTapped()
            })
            
            HStack{
                Text(model.direction)
                    .foregroundColor(.gray)
                    .kerning(1)
                    .padding(.horizontal, 10)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if(model.showIndicator){
                ProgressView()
            }
            
            ScrollView(.vertical){
                if(!model.buses.isEmpty){
                    LabelTypeTransport(typeTransport: .bus)
                    Grid(alignment: .center){
                        ForEach(model.buses){ item in
                            item.body
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
                
                if(!model.trains.isEmpty){
                    LabelTypeTransport(typeTransport: .train)
                    Grid(alignment: .center){
                        ForEach(model.trains){ item in
                            item.body
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
                
                if(!model.trolleybuses.isEmpty){
                    LabelTypeTransport(typeTransport: .trolleybus)
                    Grid(alignment: .center){
                        ForEach(model.trolleybuses){ item in
                            item.body
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
                
                if(!model.countryBuses.isEmpty){
                    LabelTypeTransport(typeTransport: .countrybus)
                    Grid(alignment: .center){
                        ForEach(model.countryBuses){ item in
                            item.body
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
            }
            .padding(.horizontal, 20)
            .opacity(model.opacity)
            .scrollIndicators(.hidden)
            
            Spacer()
            
        }
        .onAppear(){
            viewModel.getStationData()
        }
    }
}

//struct FavoriteStopOnline_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteStopOnline()
//    }
//}
