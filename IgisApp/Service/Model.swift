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
    
    static let busDict = [ 22 : 14, 25 : 16, 29 : 19]
    static let trolleybusDict  = [ 6 : 74, 9 : 76, 10 : 77]
    static let trainDict = [ 1 : 79, 9 : 86, 10 : 87]
    
    static func getTypeTransportFromId(routeId: Int) -> TypeTransport?{
        if (Model.busDict.contains { (key: Int, value: Int) in
            value == routeId
        }){
            return.bus
        }
        if (Model.trolleybusDict.contains { (key: Int, value: Int) in
            value == routeId
        }){
            return.trolleybus
        }
        if (Model.trainDict.contains { (key: Int, value: Int) in
            value == routeId
        }){
            return.train
        }
        return nil
    }
    
    static func FillMenu(configuration: Configuration){
        configuration.menu.menuItems.removeAll()
        
        var offset = 50
        if let allSubroutesThisRoute = DataBase.stopsOfRouteOld[configuration.routeId]?.arraySubroutes{
            
            allSubroutesThisRoute.forEach { direction in
                configuration.menu.menuItems.append(MenuItem(startStopId: direction.subroute.first ?? 0, endStopId: direction.subroute.last ?? 0, offset: offset))
                offset += 50
            }
            
            let firstDirection = allSubroutesThisRoute.first?.subroute
            
            configuration.menu.currentStop = MenuItem(startStopId: firstDirection?.first ?? 0, endStopId: firstDirection?.last ?? 0, offset: 0)
        }
    }
    
    static func PresentRoute(configuration: Configuration, direction: Direction? = nil){
        // Метод для отображения маршрута на экране
        var stopsOfRoute: [Int] = []
        
        // Получим все направления этого маршрута - массив направлений
        // Направление - массив остановок
        if let allSubroutesThisRoute = DataBase.stopsOfRouteOld[configuration.routeId]?.arraySubroutes{
            
            // Если направление задано, то отобразим именно его
            if direction != nil{
                // Получим то направление, которое удовлетворяет нашему условию
                stopsOfRoute = allSubroutesThisRoute.first(where: { item in
                    item.subroute.first == direction?.startStation && item.subroute.last == direction?.endStation
                })?.subroute ?? []
            }else{
                // Иначе просто отобразим первое направление этого маршрута
                stopsOfRoute = allSubroutesThisRoute.first?.subroute ?? []
            }
        }

        configuration.data.removeAll()
        
        // Заполнение вью полученным направлением - массивом остановок
        var stationState = StationState.startStation
        
        stopsOfRoute.forEach { stopId in
            if(stopId == stopsOfRoute.last) { stationState = .endStation }
            withAnimation {
                configuration.data.append(Station(id: stopId, name: DataBase.getStopName(id: stopId), stationState: stationState, pictureTs: "", time: "\(Int.random(in: 1...50)) мин"))
            }
            stationState = .someStation
        }
        
        
        ServiceAPI().fetchDataForRoute(configuration: configuration)
    }
    
    static func getRouteId(type: TypeTransport, number: Int) -> Int{
        var result = 0
        switch type{
        case .ship: break
        case .train: result = trainDict[number]!
        case .trolleybus: result = trolleybusDict[number]!
        case .bus: result = busDict[number]!
        }
        return result
    }
    
    static func getRouteNumber(routeId: Int) -> Int{
        var dict = Dictionary<Int, Int>()
        Model.trainDict.forEach { (key: Int, value: Int) in
            dict[value] = key
        }
        Model.busDict.forEach { (key: Int, value: Int) in
            dict[value] = key
        }
        Model.trolleybusDict.forEach { (key: Int, value: Int) in
            dict[value] = key
        }
        return dict[routeId] ?? 0
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
        favorites.append(Favorites.FavoriteRoute(type: .ship, numbers: []))
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteRoutes") as? [Int]{
            favoritesArray.forEach { Int in
                favorites.first { FavoriteRoute in
                    FavoriteRoute.type == Model.getTypeTransportFromId(routeId: Int)
                }?.numbers.append(Model.getRouteNumber(routeId: Int))
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
    case train = 2
    case trolleybus = 3
    case ship = 5
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


