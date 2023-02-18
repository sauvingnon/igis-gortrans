//
//  ServiceAPI.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 10.02.2023.
//

import Foundation
import SwiftUI

class ServiceAPI{
    
    func fetchDataForRoute(idRoute: Int, currentData: CurrentData, onlineData: CurrentOnlineData){
        var routeInfo: RouteStruct?
        
        let urlString = "https://testapi.igis-transport.ru/mobile-1KrXNDxI8iccaSbt/prediction-route/\(idRoute)"
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) { [self] data, response, error in
            do{
                if(data != nil){
                    let decoder = JSONDecoder()
                    routeInfo = try decoder.decode(RouteStruct.self, from: data!)
                    DispatchQueue.main.sync {
                        routeInfo?.data.ts.forEach({ ts in
                            if(ts.status == "ok"){
                                if(getDirection(route: idRoute, ts: ts) == onlineData.directon){
                                    pushTsOnRoute(ts: ts, data: currentData)
                                }
                            }
                        })
                        currentData.stops.shuffle()
                    }
                    
                }
            }
            catch {
                debugPrint(error)
            }
            
        }
        task.resume()
    }
    
    func getDirection(route: Int, ts: RouteStruct.Data.Ts) -> Direction{
        if((SomeInfo.stopsOfRoute[route]?.clasic.contains([ts.stop_current ?? 0])) != nil){
            return .clasic
        }
        if((SomeInfo.stopsOfRoute[route]?.clasic.contains([ts.stop_next ?? 0])) != nil){
            return .clasic
        }
        if((SomeInfo.stopsOfRoute[route]?.reverse.contains([ts.stop_current ?? 0])) != nil){
            return .reverse
        }
        if((SomeInfo.stopsOfRoute[route]?.reverse.contains([ts.stop_next ?? 0])) != nil){
            return .reverse
        }
        return .clasic
    }
    
    func pushTsOnRoute(ts: RouteStruct.Data.Ts, data: CurrentData){
        if(ts.stop_current != nil){
            data.stops.forEach { Station in
                if(Station.id == ts.stop_current){
                    Station.time = ""
                    Station.pictureBus = "bus_img"
                    return
                }
            }
        }
        if(ts.stop_next != nil){
            data.stops.forEach { Station in
                if(Station.id == ts.stop_next){
                    Station.time = ""
                    Station.pictureBus = "bus_next"
                    return
                }
            }
        }
    }
    
}

struct RouteStruct: Codable{
    let data: Data
    struct Data: Codable{
        let route: Route
            struct Route: Codable{
                let online: Bool
                let is_work_today: Bool
                let status: String
            }
        let ts: [Ts]
        struct Ts: Codable{
            let code: String
            let gosnumber: String
            let status: String
            let status_description: String
            let ts_reys_begin: String
            let ts_reys_end: String
            let stop_previous: Int?
            let stop_current: Int?
            let stop_next: Int?
        }
    }
    let last_modify: String
    let cache_lifetime: Int
    let copyright: String
    let version: String
}
