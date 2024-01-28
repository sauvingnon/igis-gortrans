//
//  ShowStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 27.04.2023.
//

import SwiftUI

struct ShowTransportStopView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @ObservedObject var model = ShowStopOnlineModel.shared
    private let viewModel = ShowTransportStopViewModel.shared
    
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
//        .onAppear(){
//            viewModel.getStationData()
//        }
    }
    
}

struct TransportWaiter: View, Identifiable, Equatable {
    let id = UUID()
    let transportNumber: String
    let endStationName: String
    let time: String
    var isLastSection = false
    var isFirstSection = false
    var body: some View{
        VStack{
            
            if(isFirstSection){
                GeometryReader{_ in
                    
                }
                .frame(width: UIScreen.screenWidth-40, height: 1)
                .background(Color.white.opacity(0))
            }
            
            HStack{
                Text(transportNumber)
                    .font(.title)
                    .foregroundColor(.blue)
                Spacer()
                Text(endStationName)
                    .foregroundColor(.black.opacity(0.6))
                    .kerning(2)
                Spacer()
                Text(time)
                    .font(.title)
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
            
            if(isLastSection){
                GeometryReader{_ in
                    
                }
                .frame(width: UIScreen.screenWidth-40, height: 1)
                .background(Color.black.opacity(0))
            }else{
                GeometryReader{_ in
                    
                }
                .frame(width: UIScreen.screenWidth-40, height: 1)
                .background(Color.black.opacity(0.6))
            }
            
            
            
        }
    }
}

//struct ShowStopOnline_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowStopOnline()
//    }
//}
