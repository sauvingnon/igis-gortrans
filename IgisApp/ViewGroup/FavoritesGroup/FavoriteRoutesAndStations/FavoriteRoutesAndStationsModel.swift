//
//  FavoriteRoutesAndStationsModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import Foundation

class FavoritesRoutesAndStationsModel: ObservableObject{
    static let shared = FavoritesRoutesAndStationsModel()
    
    private init() {
        self.favoriteRoutes = GeneralViewModel.getFavoriteRouteData()
        self.favoriteStops = GeneralViewModel.getFavoriteStopData()
    }
    
    @Published var favoriteRoutes: [FavoriteRoute]
    class FavoriteRoute: Identifiable{
        var id = UUID()
        var type: TypeTransport = .trolleybus
        var numbers: [String] = []
        init(type: TypeTransport, numbers: [String]) {
            self.type = type
            self.numbers = numbers
        }
    }
    
    @Published var favoriteStops: [FavoriteStop]
    class FavoriteStop: Identifiable{
        var id = UUID()
        var stopId: Int
        var stopName: String
        var stopDirection: String
        init(stopId: Int, stopName: String, stopDirection: String) {
            self.stopId = stopId
            self.stopName = stopName
            self.stopDirection = stopDirection
        }
    }
}
