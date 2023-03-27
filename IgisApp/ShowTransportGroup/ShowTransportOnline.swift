//
//  ShowTransportOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 09.02.2023.
//

import SwiftUI

struct ShowTransportOnline: View {
    
    @State var isMenuOpen = false
    
    @EnvironmentObject var navigation: NavigationTransport
    
    @ObservedObject var configuration = Configuration()
    
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
                    .foregroundColor(Model.isFavoriteRoute(routeId: configuration.routeId) ? .orange : .white)
                    .fontWeight(.black)
                    .onTapGesture {
                        // Добавление маршрута в избранное или удаление оттуда
                        Model.favoriteRouteTapped(configuration: configuration)
                    }
            }
            .onTapGesture {
                navigation.state = .chooseNumberTransport
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
            
            customMenu(menu: configuration.menu)
                .zIndex(1)
                .onChange(of: configuration.menu.currentStop, perform: { newValue in
                    let newDirection = Direction(startStation: newValue.startStopId, endStation: newValue.endStopId)
                    
                    Model.PresentRoute(configuration: configuration, direction: newDirection)
                })
            
            ScrollView{
                Grid(alignment: .trailing){
                    ForEach(configuration.data, id: \.self) { item in
                        GridRow{
                            StationRow(station: item)
                        }
                    }
                }
            }.scrollIndicators(.hidden)
            
            
            
            Spacer()
        }
    }
    
    func configureView(routeId: Int, type: TypeTransport, number: Int){
        
        configuration.type = type
        configuration.name = getName(type: type, number: number)
        configuration.routeId = routeId
        configuration.isFavorite = Model.isFavoriteRoute(routeId: routeId)
        
        Model.FillMenu(configuration: configuration)
        Model.PresentRoute(configuration: configuration)
        
//        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.getRoute), userInfo: nil, repeats: true)
    }
    
//    @objc func getRoute(){
//
//    }
    
    func getName(type: TypeTransport, number: Int) -> String {
        switch type {
        case .bus:
            return "АВТОБУС №\(number)"
        case .train:
            return "ТРАМВАЙ №\(number)"
        case .trolleybus:
            return "ТРОЛЛЕЙБУС №\(number)"
        case .countryBus:
            return "АВТОБУС №\(number)"
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
            switch(station.stationState){
            case .endStation:
                Image("endStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 30)
            case .someStation:
                Image("someStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
            case .startStation:
                Image("startStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
                    .padding(.top, 30)
            }
            
            if(!station.pictureTs.isEmpty && !station.isNext){
                HStack{
                    Image(systemName: station.pictureTs)
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width: 25, height: 25)
                }
                .frame(width: 50, height: 50)
                }else{
                    if(station.isNext){
                        VStack{
                            HStack(alignment: .top){
                                Image(systemName: station.pictureTs)
                                    .resizable()
                                    .foregroundColor(.blue)
                                    .frame(width: 20, height: 20)
                            }
                            .frame(width: 50, height: 50)
                            .offset(y: +7)
                            
                            Text(station.time)
                                .frame(width: 50, height: 50)
                                .lineLimit(1)
                                .minimumScaleFactor(0.01)
                                .offset(y: -30)
                                .foregroundColor(.gray)
                    
                        }
                        .frame(width: 50, height: 50)
                    }else{
                        Text(station.time)
                            .frame(width: 50, height: 50)
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(.gray)
                    }
                }
        }
        .frame(height: 35)
    }
    
}

struct Station: Identifiable, Hashable {
    let id: Int
    let name: String
    let stationState: StationState
    let pictureTs: String
    let time: String
    let isNext: Bool
    init(id: Int, name: String, stationState: StationState, pictureTs: String, time: String, isNext: Bool = false) {
        self.isNext = isNext
        self.id = id
        self.name = name
        self.stationState = stationState
        self.pictureTs = pictureTs
        self.time = time
    }
    // Ячейки можем пересоздать, тогда вью обновится
}

class Configuration: ObservableObject{
    @Published var name = "--"
    @Published var type = TypeTransport.bus
    @Published var number = 0
    @Published var isFavorite = false
    var routeId = 0
    @Published var menu = Menu(menuItems: [], currentStop: MenuItem(startStopId: 0, endStopId: 0, offset: 0))
    @Published var data: [Station] = []
}

extension ShowTransportOnline{
    func customMenu(menu: Menu) -> some View {
        return ZStack {
            ForEach(menu.menuItems, id: \.self){ item in
                ZStack {
                    HStack{
                        Text("\(DataBase.stops[item.startStopId] ?? "Error") - \(DataBase.stops[item.endStopId] ?? "Error")")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: UIScreen.screenWidth - 80)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Rectangle())
                    .cornerRadius(25)
                    .onTapGesture {
                        menu.currentStop = item
                        isMenuOpen.toggle()
                    }
                    .padding(.horizontal, 20)
                }
                .shadow(color: .black.opacity(isMenuOpen ? 0.1 : 0.0), radius: 10, x: 0, y: 5)
                .offset(y: isMenuOpen ? CGFloat(item.offset) : 0)
                .opacity(isMenuOpen ? 100 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5), value: isMenuOpen)
            }
            
            ZStack {
                HStack{
                    Text("\(DataBase.stops[menu.currentStop.startStopId] ?? "Error") - \(DataBase.stops[menu.currentStop.endStopId] ?? "Error")")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                    
                    Image(systemName: isMenuOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
                }
                .frame(minWidth: UIScreen.screenWidth-40)
                .padding(10)
                .background(Color.blue)
                .clipShape(Rectangle())
                .cornerRadius(25)
                .padding(.horizontal, 20)
            }
            .onTapGesture {
                isMenuOpen.toggle()
            }
            
        }
    }
}

