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
    
    static let busDict = [ 22 : 14, 25 : 16, 29 : 19]
    static let trolleybusDict  = [ 6 : 74, 9 : 76, 10 : 77]
    static let trainDict = [ 1 : 79, 9 : 86, 10 : 87]
    
    static let busArray = [ 22, 25, 29]
    static let trolleybusArray = [ 6, 9, 10]
    static let trainArray = [ 1, 9, 10]
    
    static func getArrayNum(type: TypeTransport) -> [Int]{
        var result = [ 0 ]
        switch type{
        case .countryBus: break
        case .train: result = trainArray
        case .trolleybus: result = trolleybusArray
        case .bus: result = busArray
        }
        return result
    }
    
    static func getRoutesArray(routeId: Int, currentData: CurrentData, onlineData: CurrentOnlineData){
//        DispatchQueue.main.async {
//            ServiceAPI().fetchDataForRoute(idRoute: routeId, currentData: currentData, onlineData: onlineData)
//        }
    }
    
    static func PresentRoute(routeId: Int, currentData: CurrentData, direction: Direction, currentOnlineData: CurrentOnlineData){
        // Отобразим до куда идет на кнопке - нужно доработать нажатие
        var menu = currentOnlineData.stops
        var endStop = 0
        var stopsOfRoute: [Int] = []
        var startStop = 0
        if let allStops = SomeInfo.stopsOfRoute[routeId]{
            startStop = (direction == .clasic) ? allStops.clasic[allStops.clasic.startIndex] : allStops.reverse[allStops.reverse.startIndex]
            endStop = (direction == .clasic) ? allStops.clasic[allStops.clasic.endIndex-1] : allStops.reverse[allStops.reverse.endIndex-1]
            stopsOfRoute = (direction == .clasic) ? allStops.clasic : allStops.reverse
        }
        menu.currentStop = endStop
        
        menu.menuItems.removeAll()
        menu.menuItems.append(MenuItem(stopId: endStop, offset: 50))
        menu.menuItems.append(MenuItem(stopId: startStop, offset: 100))

        currentData.stops.removeAll()
        
        stopsOfRoute.forEach { stopId in
            currentData.stops.append(Station(id: stopId, name: SomeInfo.stops[stopId] ?? "Error", pictureStation: "station_img", pictureBus: "", time: "\(Int.random(in: 1...50)) мин"))
        }
        
        
        ServiceAPI().fetchDataForRoute(idRoute: routeId, currentData: currentData, onlineData: currentOnlineData)
    }
    
    static func getRouteId(type: TypeTransport, number: Int) -> Int{
        var result = 0
        switch type{
        case .countryBus: break
        case .train: result = trainDict[number]!
        case .trolleybus: result = trolleybusDict[number]!
        case .bus: result = busDict[number]!
        }
        return result
    }
    
}

enum TypeTransport{
    case bus
    case train
    case trolleybus
    case countryBus
}

enum Direction{
    case clasic
    case reverse
}

