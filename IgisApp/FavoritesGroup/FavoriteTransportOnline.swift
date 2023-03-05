//
//  FavoriteStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.02.2023.
//

import SwiftUI

struct FavoriteTransportOnline: View {
    
    @State var isMenuOpen = false
    
    @EnvironmentObject var currentView: currentFavoritesViewClass
    
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
                currentView.state = .favorites
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
            
            customMenu(menu: currentOnlineData.menu)
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
    
    struct FavoriteTransportOnline_Previews: PreviewProvider {
        static var previews: some View {
            FavoriteTransportOnline()
        }
    }

extension FavoriteTransportOnline{
    func customMenu(menu: Menu) -> some View {
        return ZStack {
            ForEach(menu.menuItems, id: \.self){ item in
                ZStack {
                    HStack{
                        Text("\(SomeInfo.stops[item.startStopId] ?? "Error") - \(SomeInfo.stops[item.endStopId] ?? "Error")")
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
                    Text("\(SomeInfo.stops[menu.currentStop.startStopId] ?? "Error") - \(SomeInfo.stops[menu.currentStop.endStopId] ?? "Error")")
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
