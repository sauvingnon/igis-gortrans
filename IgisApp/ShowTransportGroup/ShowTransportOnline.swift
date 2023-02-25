//
//  ShowTransportOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 09.02.2023.
//

import SwiftUI

struct ShowTransportOnline: View {
    
    @State var isMenuOpen = false
    
    @EnvironmentObject var currentView: currentTransportViewClass
    
    @ObservedObject var currentOnlineData = CurrentOnlineData()
    
    @ObservedObject var currentData = CurrentData()
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                Text(currentOnlineData.transportName)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "star.fill")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Model.isFavoriteRoute(routeId: currentOnlineData.routeId) ? .orange : .white)
                    .fontWeight(.black)
                    .onTapGesture {
                        // Добавление маршрута в избранное или удаление оттуда
                        Model.favoriteRouteTapped(onlineData: currentOnlineData)
                    }
            }
            .onTapGesture {
                currentView.state = .chooseNumberTransport
            }
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.vertical, 10)
            
            //            HStack{
            //                Text(currentOnlineData.transportTimeTable)
            //                    .foregroundColor(.blue)
            //                    .fontWeight(.medium)
            //                Spacer()
            //            }
            //            .padding(.horizontal, 40)
            
            CustomMenu(menu: currentOnlineData.menu, isMenuOpen: $isMenuOpen)
                .zIndex(1)
                .onChange(of: currentOnlineData.menu.currentStop, perform: { newValue in
                    let newDirection = Direction(startStation: newValue.startStopId, endStation: newValue.endStopId)
                    
                    currentOnlineData.directon = newDirection
                    
                    Model.PresentRoute(currentData: currentData, direction: currentOnlineData.directon, currentOnlineData: currentOnlineData)
                })
            
            ScrollView{
                Grid(alignment: .trailing){
                    ForEach(currentData.stops, id: \.self) { item in
                        GridRow{
                            StationRow(station: item)
                        }
                    }
                }
            }.scrollIndicators(.hidden)
            
            
            
            Spacer()
        }
    }
    
    func updateRouteData(routeId: Int, type: TypeTransport, number: Int){
        
        currentOnlineData.routeId = routeId
        
        Model.PresentRoute(currentData: currentData, currentOnlineData: currentOnlineData)
        
        currentOnlineData.transportName = "\(getNameType(type: type)) №\(number)"
        currentOnlineData.isFavorite = Model.isFavoriteRoute(routeId: routeId)
    }
    
    func getNameType(type: TypeTransport) -> String {
        switch type {
        case .bus:
            return "АВТОБУС"
        case .train:
            return "ТРАМВАЙ"
        case .trolleybus:
            return "ТРОЛЛЕЙБУС"
        case .countryBus:
            return "АВТОБУС"
        }
    }
    
}

struct ShowTransportOnline_Previews: PreviewProvider {
    static var previews: some View {
        ShowTransportOnline()
    }
}

class CurrentData: ObservableObject{
    @Published var stops: [Station] = []
}

struct StationRow: View{
    var station: Station
    
    var body: some View{
        HStack{
            Text(station.name)
                .foregroundColor(.blue)
                .fontWeight(.light)
            Image(station.pictureStation)
                .resizable()
                .frame(width: 50, height: 50)
            if(station.time.isEmpty){
                Image(station.pictureBus)
                    .resizable()
                    .frame(width: 50, height: 50)
            }else{
                Text(station.time)
                    .frame(width: 50, height: 50)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
            }
            
        }
        .frame(height: 35)
    }
    
}

struct Station: Identifiable, Hashable {
    let id: Int
    let name: String
    let pictureStation: String
    let pictureBus: String
    let time: String
    init(id: Int, name: String, pictureStation: String, pictureBus: String, time: String) {
        self.id = id
        self.name = name
        self.pictureStation = pictureStation
        self.pictureBus = pictureBus
        self.time = time
    }
    // Ячейки можем пересоздать, тогда вью обновится
}

class CurrentOnlineData: ObservableObject{
    var directon: Direction = Direction(startStation: 0, endStation: 0)
    var routeId = 0
    var transportName = "АВТОБУС №22"
    @Published var isFavorite = false
    //    @Published var transportTimeTable = "Ежедневно 6:00 - 21:30"
    @Published var menu = Menu(menuItems: [], currentStop: MenuItem(startStopId: 0, endStopId: 0, offset: 0))
}



