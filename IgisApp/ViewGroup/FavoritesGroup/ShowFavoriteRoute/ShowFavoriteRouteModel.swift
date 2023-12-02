//
//  ShowFavoriteRouteModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import Foundation

class ShowFavoriteRouteModel: ObservableObject{
    static let shared = ShowFavoriteRouteModel()
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
}
