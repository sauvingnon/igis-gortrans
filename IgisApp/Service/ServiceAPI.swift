//
//  ServiceAPI.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 10.02.2023.
//

import Foundation
import SwiftUI

class ServiceAPI{
    
    func fetchDataForRoute(currentData: CurrentData, onlineData: CurrentOnlineData){
        var routeInfo: RouteStruct?
        
        var stationsWithBus: [Station] = []
        
        let urlString = "https://testapi.igis-transport.ru/mobile-1KrXNDxI8iccaSbt/prediction-route/\(onlineData.routeId)"
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) { [self] data, response, error in
            do{
                if(data != nil){
                    let decoder = JSONDecoder()
                    routeInfo = try decoder.decode(RouteStruct.self, from: data!)
                    DispatchQueue.main.sync {
                        routeInfo?.data.ts.forEach({ ts in
                            if(ts.status == "ok"){
                                    if let newStation = pushTsOnRoute(ts: ts){
                                        stationsWithBus.append(newStation)
                                    }
                            }
                        })
                        var result: [Station] = []
                        currentData.stops.forEach { item in
                            if let stopWithBus = stationsWithBus.first(where: { Station in
                                Station.id == item.id
                            }){
                                result.append(Station(id: item.id, name: SomeInfo.stops[item.id] ?? "Error", pictureStation: "station_img", pictureBus: stopWithBus.pictureBus, time: ""))
                            }else{
                                result.append(item)
                            }
                        }
                        currentData.stops = result
                    }
                    
                }
            }
            catch {
                debugPrint(error)
            }
            
        }
        task.resume()
    }
    
    func pushTsOnRoute(ts: RouteStruct.Data.Ts) -> Station?{
        if(ts.stop_current != nil){
            return Station(id: ts.stop_current!, name: "", pictureStation: "", pictureBus: "bus_img", time: "")
        }
        if(ts.stop_next != nil){
            return Station(id: ts.stop_next!, name: "", pictureStation: "", pictureBus: "bus_next", time: "")
        }
        return nil
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
