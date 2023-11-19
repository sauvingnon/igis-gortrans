//
//  ShowStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 27.04.2023.
//

import SwiftUI

struct ShowTransportStopView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentTransportSelectionView]
    
    @ObservedObject var model = ShowStopOnlineModel.shared
    
    @State private var sizeStar = 1.0
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                Text(model.name)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "star.fill")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Model.isFavoriteStop(stopId: model.stopId) ? .orange : .white)
                    .fontWeight(.black)
                    .scaleEffect(sizeStar)
                    .onTapGesture {
                        // Добавление маршрута в избранное или удаление
                        sizeStar = 0.5
                        withAnimation(.spring()) {
                            //                            Model.favoriteRouteTapped(configuration: configuration)
                            Vibration.medium.vibrate()
                            sizeStar = 1.0
                        }
                    }
            }
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.top, 10)
            .onTapGesture {
                dismiss()
            }
            
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
                    labelTypeTransport(typeTransport: .bus)
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
                    labelTypeTransport(typeTransport: .train)
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
                    labelTypeTransport(typeTransport: .trolleybus)
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
                    labelTypeTransport(typeTransport: .countrybus)
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
