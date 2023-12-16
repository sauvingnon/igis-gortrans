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
    
    private static var alertAlreadyShow = false
    
    static func showAlertBadResponse(){
        if(alertAlreadyShow){
            return
        }
        DispatchQueue.main.async {
            AppTabBarViewModel.shared.showAlert(title: "Ошибка", message: "Нет данных")
            self.alertAlreadyShow = true
        }
    }
    
    static func uncheckAlertAlreadyShow(){
        alertAlreadyShow = false
    }
    
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
    
    
    static func getFavoriteRouteData() -> [FavoritesRoutesAndStationsModel.FavoriteRoute]{
        var favorites: [FavoritesRoutesAndStationsModel.FavoriteRoute] = []
        favorites.append(FavoritesRoutesAndStationsModel.FavoriteRoute(type: .trolleybus, numbers: []))
        favorites.append(FavoritesRoutesAndStationsModel.FavoriteRoute(type: .train, numbers: []))
        favorites.append(FavoritesRoutesAndStationsModel.FavoriteRoute(type: .bus, numbers: []))
        favorites.append(FavoritesRoutesAndStationsModel.FavoriteRoute(type: .countrybus, numbers: []))
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
    
    static func getFavoriteStopData() -> [FavoritesRoutesAndStationsModel.FavoriteStop]{
        var favorites: [FavoritesRoutesAndStationsModel.FavoriteStop] = []
        
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteStops") as? [Int]{
            favoritesArray.forEach { Int in
                favorites.append(FavoritesRoutesAndStationsModel.FavoriteStop(stopId: Int, stopName: DataBase.getStopName(stopId: Int), stopDirection: DataBase.getStopDirection(stopId: Int)))
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
    
    static func getPictureTransport(type: String) -> String {
        switch type {
        case "citybus":
            return "bus"
        case "tram":
            return "tram"
        case "trolleybus":
            return "bus.doubledecker"
        case "suburbanbus":
            return "bus.fill"
        default:
            return ""
        }
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
    
//    static func getPictureTransport(type: String) -> String {
//        switch type {
//        case "citybus":
//            return "bus_icon"
//        case "train_icon":
//            return "tram"
//        case "trolleybus":
//            return "trolleybus_icon"
//        case "suburbanbus":
//            return "bus.fill"
//        default:
//            return ""
//        }
//    }

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


