//
//  Model.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import Foundation
import SwiftUI
import CoreData

class Model{
    
    static var favoritesView: FavoritesView?
    
    static func FillMenu(configuration: Configuration){
        configuration.menu.menuItems.removeAll()
        
        var offset = 50
        if let allSubroutesThisRoute = DataBase.getStopsOfRoute(routeId: configuration.routeId){
            
            allSubroutesThisRoute.forEach { direction in
                configuration.menu.menuItems.append(MenuItem(startStopId: direction.subroute_stops.first ?? 0, endStopId: direction.subroute_stops.last ?? 0, offset: offset))
                offset += 50
            }
            
            let firstDirection = allSubroutesThisRoute.first?.subroute_stops
            
            configuration.menu.currentStop = MenuItem(startStopId: firstDirection?.first ?? 0, endStopId: firstDirection?.last ?? 0, offset: 0)
        }
    }
    
    static func PresentRoute(configuration: Configuration, direction: Direction? = nil){
        // Метод для отображения маршрута на экране
        var stopsOfRoute: [Int] = []
        
        // Получим все направления этого маршрута - массив направлений
        // Направление - массив остановок
        if let allSubroutesThisRoute = DataBase.getStopsOfRoute(routeId: configuration.routeId){
            
            // Если направление задано, то отобразим именно его
            if direction != nil{
                // Получим то направление, которое удовлетворяет нашему условию
                stopsOfRoute = allSubroutesThisRoute.first(where: { item in
                    item.subroute_stops.first == direction?.startStation && item.subroute_stops.last == direction?.endStation
                })?.subroute_stops ?? []
            }else{
                // Иначе просто отобразим первое направление этого маршрута
                stopsOfRoute = allSubroutesThisRoute.first?.subroute_stops ?? []
            }
        }

        configuration.data.removeAll()
        
        // Заполнение вью полученным направлением - массивом остановок
        var stationState = StationState.startStation
        
        stopsOfRoute.forEach { stopId in
            if(stopId == stopsOfRoute.last) { stationState = .endStation }
            withAnimation {
                configuration.data.append(Station(id: stopId, name: DataBase.getStopName(stopId: stopId), stationState: stationState, pictureTs: "", time: "\(Int.random(in: 1...50)) мин"))
            }
            stationState = .someStation
        }
        
        
        ServiceAPI().fetchDataForRoute(configuration: configuration)
    }
    
    static func favoriteRouteTapped(configuration: Configuration){
        if var favoritesArray = UserDefaults.standard.array(forKey: "FavoriteRoutes") as? [Int]{
            if isFavoriteRoute(routeId: configuration.routeId){
                favoritesArray.removeAll { item in
                    item == configuration.routeId
                }
                configuration.isFavorite = false
            }else{
                favoritesArray.append(configuration.routeId)
                configuration.isFavorite = true
            }
            UserDefaults.standard.set(favoritesArray, forKey: "FavoriteRoutes")
            
        }else{
            UserDefaults.standard.set([configuration.routeId], forKey: "FavoriteRoutes")
        }
        self.favoritesView?.favorites.items = getFavoriteData()
    }
    
    static func isFavoriteRoute(routeId: Int) -> Bool{
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteRoutes") as? [Int]{
            return favoritesArray.contains { item in
                item == routeId
            }
        }
        return false
    }
    
    static func getFavoriteData() -> [Favorites.FavoriteRoute]{
        var favorites: [Favorites.FavoriteRoute] = []
        favorites.append(Favorites.FavoriteRoute(type: .trolleybus, numbers: []))
        favorites.append(Favorites.FavoriteRoute(type: .train, numbers: []))
        favorites.append(Favorites.FavoriteRoute(type: .bus, numbers: []))
        favorites.append(Favorites.FavoriteRoute(type: .countrybus, numbers: []))
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteRoutes") as? [Int]{
            favoritesArray.forEach { Int in
                favorites.first { FavoriteRoute in
                    FavoriteRoute.type == DataBase.getTypeTransportFromId(routeId: Int)
                }?.numbers.append(DataBase.getRouteNumber(routeId: Int))
            }
        }
        favorites.removeAll { FavoriteRoute in
            FavoriteRoute.numbers.count == 0
        }
        return favorites
    }
}

enum TypeTransport: Int {
    case bus = 1
    case train = 3
    case trolleybus = 2
    case countrybus = 5
}

enum StationState{
    case startStation
    case someStation
    case endStation
}

struct Direction{
    let startStation: Int
    let endStation: Int
}


