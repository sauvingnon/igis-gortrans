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
    
    private var columns: [GridItem] = [
        GridItem(.fixed(200)),
        GridItem(.fixed(200)),
        GridItem(.fixed(200))
    ]
    
    var body: some View {
        VStack{
            HStack{
                Text(currentOnlineData.transportName)
                    .padding(.leading, 30)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
                    .fontWeight(.black)
            }
            .onTapGesture {
                currentView.state = .chooseNumberTransport
            }
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.vertical, 10)
            
            HStack{
                Text(currentOnlineData.transportTimeTable)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal, 40)
            
            customMenu(menu: currentOnlineData.stops, currentOnlineData: currentOnlineData)
                .zIndex(1)
                .onTapGesture {
                    var direction: Direction = .reverse
                    if currentOnlineData.stops.currentStop == SomeInfo.stopsOfRoute[currentOnlineData.routeId]?.clasic[ (SomeInfo.stopsOfRoute[currentOnlineData.routeId]?.clasic.endIndex ?? 0)-1]{
                        direction = .clasic
                    }
                    
                    Model.PresentRoute(routeId: currentOnlineData.routeId, currentData: currentData, direction: direction, currentOnlineData: currentOnlineData)
                }
            
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
    
    func updateRouteData(routeId: Int, type: TypeTransport, number: Int, direction: Direction = .clasic){
        
        Model.PresentRoute(routeId: routeId, currentData: currentData, direction: direction, currentOnlineData: currentOnlineData)
        
        currentOnlineData.transportName = "\(getNameType(type: type)) №\(number)"
        currentOnlineData.routeId = routeId
        
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
    var directon: Direction = .clasic
    var routeId = 0
    @Published var transportName = "АВТОБУС №22"
    @Published var transportTimeTable = "Ежедневно 6:00 - 21:30"
    @Published var stops = Menu(menuItems: [], currentStop: 0)
}

extension ShowTransportOnline{
    func customMenu(menu: Menu, currentOnlineData: CurrentOnlineData) -> some View{
        ZStack {
            ForEach(menu.menuItems, id: \.self){ item in
                ZStack {
                    HStack{
                        Text("ДО \(SomeInfo.stops[item.stopId]?.uppercased() ?? "Error")")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                    }
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Rectangle())
                    .cornerRadius(25)
                    .onTapGesture {
                        menu.currentStop = item.stopId
                        isMenuOpen.toggle()
                        if currentOnlineData.stops.currentStop == SomeInfo.stopsOfRoute[currentOnlineData.routeId]?.clasic[ (SomeInfo.stopsOfRoute[currentOnlineData.routeId]?.clasic.endIndex ?? 0)-1]{
                            currentOnlineData.directon = .clasic
                        }else{
                            currentOnlineData.directon = .reverse
                        }
                        
                        Model.PresentRoute(routeId: currentOnlineData.routeId, currentData: currentData, direction: currentOnlineData.directon, currentOnlineData: currentOnlineData)
                    }
                }
                .shadow(color: .black.opacity(isMenuOpen ? 0.1 : 0.0), radius: 10, x: 0, y: 5)
                .offset(y: isMenuOpen ? CGFloat(item.offset) : 0)
                .opacity(isMenuOpen ? 100 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5), value: isMenuOpen)
            }
            
            ZStack {
                HStack{
                    Text("ДО \(SomeInfo.stops[menu.currentStop]?.uppercased() ?? "Error")")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                    
                    Image(systemName: isMenuOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
                }
                .frame(minWidth: 250)
                .padding(10)
                .background(Color.blue)
                .clipShape(Rectangle())
                .cornerRadius(25)
            }
            .onTapGesture {
                isMenuOpen.toggle()
            }
        }
    }
}

