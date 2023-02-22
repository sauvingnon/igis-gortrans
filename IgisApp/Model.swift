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
    
    static func PresentRoute(currentData: CurrentData, direction: Direction? = nil, currentOnlineData: CurrentOnlineData){
        // Метод для отображения маршрута на экране
        let menu = currentOnlineData.menu
        var stopsOfRoute: [Int] = []
        
        if let allSubroutesThisRoute = SomeInfo.stopsOfRoute[currentOnlineData.routeId]?.arraySubroutes{
            
            if direction != nil{
                stopsOfRoute = allSubroutesThisRoute.first(where: { item in
                    item.subroute.first == direction?.startStation && item.subroute.last == direction?.endStation
                })?.subroute ?? []
            }else{
                stopsOfRoute = allSubroutesThisRoute.first?.subroute ?? []
                
                menu.currentStop = MenuItem(startStopId: stopsOfRoute.first ?? 0, endStopId: stopsOfRoute.last ?? 0, offset: 0)
            }
            
            menu.menuItems.removeAll()
            
            var offsetter = 50
            allSubroutesThisRoute.forEach { item in
                menu.menuItems.append(MenuItem(startStopId: item.subroute.first ?? 0, endStopId: item.subroute.last ?? 0, offset: offsetter))
                offsetter += 50
            }
        }

        currentData.stops.removeAll()
        
        stopsOfRoute.forEach { stopId in
            currentData.stops.append(Station(id: stopId, name: SomeInfo.stops[stopId] ?? "Error", pictureStation: "station_img", pictureBus: "", time: "\(Int.random(in: 1...50)) мин"))
        }
        
        
        ServiceAPI().fetchDataForRoute(currentData: currentData, onlineData: currentOnlineData)
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

struct Direction{
    let startStation: Int
    let endStation: Int
}

