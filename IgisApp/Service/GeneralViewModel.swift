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

class GeneralViewModel{

    static var userTrace = ""
    
    static func checkConnection(){
        let queue = DispatchQueue.global(qos: .default)
        var isOnline = false
        var status: SocketIOStatus = .notConnected
        
        queue.async {
            while(true){
                if(isOnline == GeneralViewModel.setCurrentModeNetwork() && status == ServiceSocket.status && status == .connected){
                    sleep(1)
                    continue
                }
                isOnline = GeneralViewModel.setCurrentModeNetwork()
                status = ServiceSocket.status
                if(isOnline){
                    switch(status){
                    case .notConnected:
                        debugPrint("запущен процесс соединения с сервером")
                        AppTabBarViewModel.shared.changeStatus(isConnected: .waitSocket)
                        ServiceSocket.shared.establishConnection()
                    case .disconnected:
                        debugPrint("был отключен сервером, переподключение вручную \(Date.now)")
                        sleep(5)
                        ServiceSocket.shared.establishConnection()
                    case .connecting:
                        debugPrint("ожидание сокет-сервера \(Date.now)")
                        AppTabBarViewModel.shared.changeStatus(isConnected: .waitSocket)
                    case .connected:
                        debugPrint("сокет-сервер подключен \(Date.now)")
                        AppTabBarViewModel.shared.changeStatus(isConnected: .isConnected)
                    }
                }else{
                    debugPrint("сокет-сервер не подключен \(Date.now)")
                    AppTabBarViewModel.shared.changeStatus(isConnected: .notConnected)
                }
                sleep(2)
            }
        }
    }
    
    static func checkTrace(){
        // метод для проверки наличия уникального следа пользователя и его генерации при отсутствии
        
        if let trace = UserDefaults.standard.string(forKey: "UserTrace"){
            self.userTrace = trace
            debugPrint("user-trace был установлен")
        }else{
            let trace = generateTrace()
            UserDefaults.standard.set(trace, forKey: "UserTrace")
            self.userTrace = trace
            debugPrint("user-trace был сгенерирован")
        }
    }
    
    static func getTimeToArrivalInMin(sec: Int) -> String{
        if(sec < 0){
            return "—"
        }
        var min = sec/60
        if min == 0{
            min = 1
        }
        return "\(min) мин"
    }
    
    static func getTimeToArrivalInMinWithoutLetters(sec: Int) -> String{
        if(sec < 0){
            return "—"
        }
        var min = sec/60
        if min == 0{
            min = 1
        }
        return "\(min)"
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
                SettingsModel.shared.offlineMode = true
            }
            return false
        }else{
            DispatchQueue.main.async {
                SettingsModel.shared.offlineMode = false
            }
            return true
        }
    }
    
    
    static func setAttributedStringFromHTML(htmlText: String) -> String? {
        let htmlData = NSString(string: htmlText).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                  options: options,
                                                                  documentAttributes: nil)
        
        return attributedString?.string
    }
    
    
    static func getFavoriteRouteData() -> [FavoritesRoutesAndStopsModel.FavoriteRoute]{
        var favorites: [FavoritesRoutesAndStopsModel.FavoriteRoute] = []
        favorites.append(FavoritesRoutesAndStopsModel.FavoriteRoute(type: .trolleybus, numbers: []))
        favorites.append(FavoritesRoutesAndStopsModel.FavoriteRoute(type: .train, numbers: []))
        favorites.append(FavoritesRoutesAndStopsModel.FavoriteRoute(type: .bus, numbers: []))
        favorites.append(FavoritesRoutesAndStopsModel.FavoriteRoute(type: .countrybus, numbers: []))
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteRoutes") as? [Int]{
            favoritesArray.forEach { routeId in
                
                var route = DataBase.getRouteNumber(routeId: routeId)
                
                if(route.contains("№")){
                    route.removeFirst(2)
                }
                
                favorites.first { FavoriteRoute in
                    FavoriteRoute.type == DataBase.getTypeTransportFromId(routeId: routeId)
                }?.numbers.append(route)
            }
        }
        favorites.removeAll { FavoriteRoute in
            FavoriteRoute.numbers.count == 0
        }
        return favorites
    }
    
    static func favoritesIsExists() -> Bool{
        guard let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteRoutes") as? [Int] else {
            return false
        }
        
        return favoritesArray.count != 0
        
    }
    
    static func getFavoriteRouteId() -> [Int]{
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteRoutes") as? [Int]{
            return favoritesArray
        }else{
            return []
        }
    }
    
    static func getFavoriteStopData() -> [StopItem]{
        var favorites: [StopItem] = []
        
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteStops") as? [Int]{
            favoritesArray.forEach { stop_id in
                
                let stopsType = DataBase.getTypesTransportForStop(stopId: stop_id)
                
                favorites.append(StopItem(stop_id: stop_id, typeTransportList: stopsType, stopName: DataBase.getStopName(stopId: stop_id), stopDirection: DataBase.getStopDirection(stopId: stop_id)))
            }
        }
        
        return favorites
    }
    
    static func isFavoriteRoute(routeId: Int) -> Bool{
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteRoutes") as? [Int]{
            return favoritesArray.contains { item in
                item == routeId
            }
        }
        return false
    }
    
    static func isFavoriteStop(stopId: Int) -> Bool{
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteStops") as? [Int]{
            return favoritesArray.contains { item in
                item == stopId
            }
        }
        return false
    }
    
    static func getPictureTransportWhite(type: String) -> String {
        switch type {
        case "citybus":
            return "bus_icon_white"
        case "tram":
            return "train_icon_white"
        case "trolleybus":
            return "trolleybus_icon_white"
        case "suburbanbus":
            return "bus_icon_white"
        default:
            return ""
        }
    }
    
    static func getPictureTransportColor(type: String) -> String {
        switch type {
        case "citybus":
            return "bus_icon_orange"
        case "tram":
            return "train_icon_red"
        case "trolleybus":
            return "trolleybus_icon_blue"
        case "suburbanbus":
            return "bus_icon_orange"
        default:
            return ""
        }
    }
    
    static func getTransportColor(typeIgis: String? = nil, type: TypeTransport? = nil) -> Color {
        
        if let type = typeIgis{
            switch typeIgis {
            case "citybus":
                return Color.orange
            case "tram":
                return Color.red
            case "trolleybus":
                return Color.blue
            case "suburbanbus":
                return Color.init(red: 0, green: 0.85, blue: 0.85)
            default:
                return Color.blue
            }
        }
        
        if let type = type{
            switch(type){
            case .bus:
                return Color.orange
            case .train:
                return Color.red
            case .trolleybus:
                return Color.blue
            case .countrybus:
                return Color.init(red: 0, green: 0.85, blue: 0.85)
            }
        }
        
        return .blue
    }
    
    static func getTransportTypeFromString(transport_type: String) -> TypeTransport {
        switch(transport_type){
        case "citybus":
            return .bus
        case "tram":
            return .train
        case "trolleybus":
            return .trolleybus
        case "suburbanbus":
            return .countrybus
        default:
            debugPrint("Ошибка распознавания типа транспорта.")
            return .bus
        }
    }
        
    static func getName(type: TypeTransport?, number: String) -> String {
        if(number.isEmpty){
            return "—"
        }
        
        if(type == nil){
            if(number.first!.isNumber){
                return "ТС №\(number)"
            }else{
                return "ТС \(number)"
            }
        }
        
        if(number.first!.isNumber){
            switch type! {
            case .bus:
                return "АВТОБУС №\(number)"
            case .train:
                return "ТРАМВАЙ №\(number)"
            case .trolleybus:
                return "ТРОЛЛЕЙБУС №\(number)"
            case .countrybus:
                return "АВТОБУС №\(number)"
            }
        }else{
            switch type! {
            case .bus:
                return "АВТОБУС \(number)"
            case .train:
                return "ТРАМВАЙ \(number)"
            case .trolleybus:
                return "ТРОЛЛЕЙБУС \(number)"
            case .countrybus:
                return "АВТОБУС \(number)"
            }
        }
    }

}

enum TypeTransport: Int {
    case bus = 1
    case train = 3
    case trolleybus = 2
    case countrybus = 5
}

enum StopState{
    case startStop
    case someStop
    case endStop
}

struct Direction{
    let startStop: Int
    let endStop: Int
}


