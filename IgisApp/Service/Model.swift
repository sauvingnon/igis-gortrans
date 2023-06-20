//
//  Model.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import Foundation
import SwiftUI
import CoreData
import SocketIO

class Model{
    
    static var favoritesView: FavoritesView?
    static var appTabBarView: AppTabBarView?
    static var settingsView: SettingsView?
    static var userTrace = ""
    
    static func checkConnection(){
        let queue = DispatchQueue.global()
        var isOnline = false
        var status: SocketIOStatus = .notConnected
        
        queue.async {
            while(true){
                if(isOnline == Model.setCurrentModeNetwork() && status == ServiceSocket.status && status == .connected){
                    continue
                }
                isOnline = Model.setCurrentModeNetwork()
                status = ServiceSocket.status
                if(!isOnline){
                    debugPrint("сокет-сервер не подключен \(Date.now)")
                    appTabBarView?.changeStatus(isConnected: .notConnected)
//                    appTabBarView?.showAlert(title: "Соединение потеряно", message: "Оффлайн режим активирован")
                }else{
                    if(status == .connected){
                        debugPrint("сокет-сервер подключен \(Date.now)")
                        appTabBarView?.changeStatus(isConnected: .isConnected)
                    }else{
                        debugPrint("ожидание сокет-сервера \(Date.now)")
                        appTabBarView?.changeStatus(isConnected: .waitSocket)
                        ServiceSocket.shared.establishConnection()
                    }
//                    appTabBarView?.showAlert(title: "Соединение установлено", message: "Оффлайн режим выключен")
                }
                sleep(2)
            }
        }
    }
    
    static func checkTrace(){
        // метод для проверки наличия уникального следа пользователя и его генерации при отсутствии
        
        if let trace = UserDefaults.standard.string(forKey: "UserTrace"){
            self.userTrace = trace
            debugPrint("userTrace was setted")
        }else{
            let trace = generateTrace()
            UserDefaults.standard.set(trace, forKey: "UserTrace")
            self.userTrace = trace
        }
    }
    
    static func getTimeToArrivalInMin(sec: Int) -> String{
        if(sec < 0){
            return "--"
        }
        var min = sec/60
        if min == 0{
            min = 1
        }
        return "\(min) мин"
    }
    
    private static func generateTrace() -> String{
        let abc = "abcdefghijklmnopqrstuvwxyz=!%*12345678900"
        var trace = "";
        while (trace.count < 64) {
            trace.append(String(abc.randomElement()!))
        }
        return trace
    }
    
    static func setCurrentModeNetwork() -> Bool{
        if CheckInternetConnection.currentReachabilityStatus() == .notReachable {
            DispatchQueue.main.async {
                settingsView?.configuration.offlineMode = true
            }
            return false
        }else{
            DispatchQueue.main.async {
                settingsView?.configuration.offlineMode = false
            }
            return true
        }
    }
    
    static func FillMenu(configuration: ConfigurationTransportOnline){
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
    
    static func PresentRoute(configuration: ConfigurationTransportOnline, direction: Direction? = nil){
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
                // Иначе отобразим приоритетное направление маршрута, это то у которого subroute_main = 1
                // Если и такого нет - отобразим первое попавшиеся - иначе пустой массив
                stopsOfRoute = allSubroutesThisRoute.first(where: { item in
                    item.subroute_main == 1
                })?.subroute_stops ?? allSubroutesThisRoute.first?.subroute_stops ?? []
            }
        }
        
        configuration.data.removeAll()
        
        // Заполнение вью полученным направлением - массивом остановок
        var stationState = StationState.startStation
        
        stopsOfRoute.forEach { stopId in
            if(stopId == stopsOfRoute.last) { stationState = .endStation }
            withAnimation {
                configuration.data.append(Station(id: stopId, name: DataBase.getStopName(stopId: stopId), stationState: stationState, pictureTs: "", time: "--"))
            }
            stationState = .someStation
        }
        
        ServiceSocket.shared.getRouteData(configuration: configuration)
//        ServiceAPI().fetchDataForRoute(configuration: configuration)
    }
    
    static func favoriteRouteTapped(configuration: ConfigurationTransportOnline){
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
            favoritesArray.sort()
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
    
    static func isFavoriteStop(stopId: Int) -> Bool{
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteStops") as? [Int]{
            return favoritesArray.contains { item in
                item == stopId
            }
        }
        return false
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


