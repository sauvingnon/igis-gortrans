//
//  ShowStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 27.04.2023.
//

import SwiftUI

struct ShowStopOnline: View {
    
    @EnvironmentObject var navigation: NavigationTransport
    
    @ObservedObject private var configuration = ConfigurationStop()
    
    @State private var sizeStar = 1.0
    @State private var scaleBack = 1.0
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                Text(configuration.name)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "star.fill")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Model.isFavoriteStop(stopId: configuration.stopId) ? .orange : .white)
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
            .onTapGesture {
                scaleBack = 1.5
                withAnimation(.spring(dampingFraction: 0.5)){
                    scaleBack = 1.0
                }
                navigation.show(view: .selectStopView)
            }
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.top, 10)
            .scaleEffect(scaleBack)
            
            HStack{
                Text(configuration.direction)
                    .foregroundColor(.gray)
                    .kerning(1)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ScrollView(.vertical){
                if(!configuration.buses.isEmpty){
                    labelTypeTransport(typeTransport: .bus)
                    Grid(alignment: .center){
                        ForEach(configuration.buses){ item in
                            item.body
                        }
                    }
                }
            }
            
            Spacer()
            
        }
    }
}

struct TransportWaiter: View, Identifiable {
    var id: ObjectIdentifier = ObjectIdentifier(Self.Type.self)
    var transportNumber = "№29"
    var endStationName = "До Парк имени Кирова"
    var time = "18:09"
    var body: some View{
        VStack{
            HStack{
                Text(transportNumber)
                    .font(.title)
                    .foregroundColor(.blue)
                Spacer()
                Text(endStationName)
                    .kerning(2)
                Spacer()
                Text(time)
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
            
            GeometryReader{_ in
                
            }
            .frame(width: UIScreen.screenWidth-40, height: 1)
            .background(Color.black)
        }
    }
}

class ConfigurationStop: ObservableObject{
    @Published var name = "мкрн Нагорный"
    @Published var direction = "В строну ж/д вокзала"
    @Published var stopId = 0
    @Published var isFavorite = false
    
    @Published var trains: [TransportWaiter] = []
    @Published var buses: [TransportWaiter] = [ TransportWaiter(), TransportWaiter(), TransportWaiter(), TransportWaiter(), TransportWaiter()]
    @Published var trolleybuses: [TransportWaiter] = []
    @Published var countryBusses: [TransportWaiter] = []
}

struct ShowStopOnline_Previews: PreviewProvider {
    static var previews: some View {
        ShowStopOnline()
    }
}
