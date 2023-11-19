//
//  FavoriteStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.02.2023.
//

import SwiftUI

struct FavoriteRouteOnline: View {
    
    @State var isMenuOpen = false
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentFavoritesSelectionView]
    
    @ObservedObject var model = FavoriteRouteOnlineModel.shared
    
    @State var sizeStar = 1.0
    @State var scaleBack = 1.0
    
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
                    .foregroundColor(Model.isFavoriteRoute(routeId: model.routeId) ? .orange : .white)
                    .fontWeight(.black)
                    .scaleEffect(sizeStar)
                    .onTapGesture {
                        // Добавление маршрута в избранное или удаление
                        sizeStar = 0.5
                        withAnimation(.spring()) {
//                            Model.favoriteRouteTapped(configuration: model)
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
//                navigator.show(view: .favorites)
            }
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.vertical, 10)
            .scaleEffect(scaleBack)
            
            customMenu(menu: model.menu)
                .zIndex(1)
                .onChange(of: model.menu.currentStop, perform: { newValue in
                    
                    let newDirection = Direction(startStation: newValue.startStopId, endStation: newValue.endStopId)
                    
//                    Model.PresentRoute(configuration: model, direction: newDirection)
                })
            
//            ScrollView{
//                Grid(alignment: .trailing){
//                    ForEach(model.data, id: \.self) { item in
//                        GridRow{
//                            StationRow(station: item)
//                        }
//                    }
//                }
//            }.scrollIndicators(.hidden)
            
            Spacer()
        }.onTapGesture {
            isMenuOpen = false
        }
    }
    
    func configureView(routeId: Int, type: TypeTransport, number: String){
        
        model.type = type
        model.name = getName(type: type, number: number)
        model.routeId = routeId
        model.isFavorite = Model.isFavoriteRoute(routeId: routeId)
        
//        Model.FillMenu(configuration: model)
//        Model.PresentRoute(configuration: model)
    }
    
    func getName(type: TypeTransport, number: String) -> String {
        switch type {
        case .bus:
            return "АВТОБУС №\(number)"
        case .train:
            return "ТРАМВАЙ №\(number)"
        case .trolleybus:
            return "ТРОЛЛЕЙБУС №\(number)"
        case .countrybus:
            return "АВТОБУС №\(number)"
        }
    }
    
}

class FavoriteRouteOnlineModel: ObservableObject{
    static let shared = FavoriteRouteOnlineModel()
    private init(){
        
    }
    
    var alert: ChooseTimeAlert?
    @Published var alertIsPresented = false
    @Published var name = "--"
    @Published var type = TypeTransport.bus
    @Published var number = "--"
    @Published var isFavorite = false
    var routeId = 0
    @Published var menu = Menu(menuItems: [], currentStop: MenuItem(startStopId: 0, endStopId: 0, offset: 0))
    @Published var data: [Station] = []
    
    static func configureView(routeId: Int, type: TypeTransport, number: String){
        
        ShowTransportRouteModel.shared.type = type
        ShowTransportRouteModel.shared.name = getName(type: type, number: number)
        ShowTransportRouteModel.shared.routeId = routeId
        ShowTransportRouteModel.shared.isFavorite = Model.isFavoriteRoute(routeId: routeId)
        ShowTransportRouteModel.shared.number = number
        
//        Model.FillMenu(configuration: ShowTransportRouteModel.shared)
//        Model.PresentRoute(configuration: ShowTransportRouteModel.shared)
        
    }
    
    static func getName(type: TypeTransport, number: String) -> String {
        switch type {
        case .bus:
            return "АВТОБУС №\(number)"
        case .train:
            return "ТРАМВАЙ №\(number)"
        case .trolleybus:
            return "ТРОЛЛЕЙБУС №\(number)"
        case .countrybus:
            return "АВТОБУС №\(number)"
        }
    }
    
}
    
//    struct FavoriteTransportOnline_Previews: PreviewProvider {
//        static var previews: some View {
//            FavoriteTransportOnline()
//        }
//    }

extension FavoriteRouteOnline{
    func customMenu(menu: Menu) -> some View {
        return ZStack {
            ForEach(menu.menuItems, id: \.self){ item in
                ZStack {
                    HStack{
                        Text("\(DataBase.getStopName(stopId: item.startStopId)) - \(DataBase.getStopName(stopId: item.endStopId))")
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
                    Text("\(DataBase.getStopName(stopId: menu.currentStop.startStopId)) - \(DataBase.getStopName(stopId: menu.currentStop.endStopId))")
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
