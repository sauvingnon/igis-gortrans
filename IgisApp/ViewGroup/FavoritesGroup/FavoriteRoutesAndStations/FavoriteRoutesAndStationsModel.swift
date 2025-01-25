//
//  FavoriteRoutesAndStopsModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import Foundation

class FavoritesRoutesAndStopsModel: ObservableObject{
    static let shared = FavoritesRoutesAndStopsModel()
    
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
    
    @Published var favoriteStops: [StopItem]
}
