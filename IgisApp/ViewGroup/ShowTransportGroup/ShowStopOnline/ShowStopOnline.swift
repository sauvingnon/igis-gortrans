//
//  ShowStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 27.04.2023.
//

import SwiftUI

struct ShowStopOnline: View {
    
    @EnvironmentObject var coordinator: coordinatorTransport
    
    @ObservedObject var configuration = ConfigurationStop()
    
    @State private var sizeStar = 1.0
    
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
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.top, 10)
            .onTapGesture {
                coordinator.show(view: configuration.oldCoordinatorView)
            }
            
            HStack{
                Text(configuration.direction)
                    .foregroundColor(.gray)
                    .kerning(1)
                    .padding(.horizontal, 10)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if(configuration.showIndicator){
                ProgressView()
            }
            
            ScrollView(.vertical){
                if(!configuration.buses.isEmpty){
                    labelTypeTransport(typeTransport: .bus)
                    Grid(alignment: .center){
                        ForEach(configuration.buses){ item in
                            item.body
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
                
                if(!configuration.trains.isEmpty){
                    labelTypeTransport(typeTransport: .train)
                    Grid(alignment: .center){
                        ForEach(configuration.trains){ item in
                            item.body
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
                
                if(!configuration.trolleybuses.isEmpty){
                    labelTypeTransport(typeTransport: .trolleybus)
                    Grid(alignment: .center){
                        ForEach(configuration.trolleybuses){ item in
                            item.body
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
                
                if(!configuration.countryBuses.isEmpty){
                    labelTypeTransport(typeTransport: .countrybus)
                    Grid(alignment: .center){
                        ForEach(configuration.countryBuses){ item in
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
            .opacity(configuration.opacity)
            .scrollIndicators(.hidden)
            
            Spacer()
            
        }
    }
    
    func configureView(stop_id: Int){
        configuration.stopId = stop_id
        configuration.name = DataBase.getStopName(stopId: stop_id)
        configuration.direction = DataBase.getStopDirection(stopId: stop_id)
        configuration.isFavorite = Model.isFavoriteStop(stopId: stop_id)
        
        ServiceSocket.shared.getStationData(configuration: configuration)
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

class ConfigurationStop: ObservableObject{
    @Published var opacity = 1.0
    var name = "мкрн Нагорный"
    var direction = "В строну ж/д вокзала"
    @Published var stopId = 0
    @Published var isFavorite = false
    @Published var showIndicator = false
    var oldCoordinatorView: CurrentTransportSelectionView = .selectStopView
    
    @Published private var trains_private: [TransportWaiter] = []
    var trains: [TransportWaiter]{
        get{
            return trains_private
        }
        set{
            trains_private = newValue
            let count = trains_private.count
            if count > 0{
                trains_private[count-1].isLastSection = true
                trains_private[0].isFirstSection = true
            }
        }
    }
    @Published private var buses_private: [TransportWaiter] = []
    var buses: [TransportWaiter]{
        get{
            return buses_private
        }
        set{
            buses_private = newValue
            let count = buses_private.count
            if count > 0{
                buses_private[count-1].isLastSection = true
                buses_private[0].isFirstSection = true
            }
        }
    }
    @Published private var trolleybuses_private: [TransportWaiter] = []
    var trolleybuses: [TransportWaiter]{
        get{
            return trolleybuses_private
        }
        set{
            trolleybuses_private = newValue
            let count = trolleybuses_private.count
            if count > 0{
                trolleybuses_private[count-1].isLastSection = true
                trolleybuses_private[0].isFirstSection = true
            }
        }
    }
    @Published private var countryBuses_private: [TransportWaiter] = []
    var countryBuses: [TransportWaiter]{
        get{
            return countryBuses_private
        }
        set{
            countryBuses_private = newValue
            let count = countryBuses_private.count
            if count > 0{
                countryBuses_private[count-1].isLastSection = true
                countryBuses_private[0].isFirstSection = true
            }
        }
    }
    
    func showData(){
        withAnimation{
            opacity = 1.0
        }
    }
}

struct ShowStopOnline_Previews: PreviewProvider {
    static var previews: some View {
        ShowStopOnline()
    }
}
