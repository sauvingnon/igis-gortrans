//
//  ServiceAPI.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 10.02.2023.
//

import Foundation
import SwiftUI

class ServiceAPI{
    
    func fetchDataForRoute(configuration: Configuration){
        var routeInfo: RouteStruct?
        
        var stationsWithBus: [Station] = []
        
        let urlString = "https://testapi.igis-transport.ru/mobile-1KrXNDxI8iccaSbt/prediction-route/\(configuration.routeId)"
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) { [self] data, response, error in
            do{
                if(data != nil){
                    let decoder = JSONDecoder()
                    routeInfo = try decoder.decode(RouteStruct.self, from: data!)
                        routeInfo?.data.ts.forEach({ ts in
                            if(ts.status == "ok"){
                                if let newStation = pushTsOnRoute(ts: ts, type: configuration.type){
                                        stationsWithBus.append(newStation)
                                    }
                            }
                        })
                        var result: [Station] = []
                        configuration.data.forEach { item in
                            if let stopWithBus = stationsWithBus.first(where: { Station in
                                Station.id == item.id
                            }){
                                result.append(Station(id: item.id, name: DataBase.stops[item.id] ?? "Error", stationState: item.stationState, pictureTs: stopWithBus.pictureTs, time: "1 мин", isNext: stopWithBus.isNext))
                            }else{
                                result.append(item)
                            }
                        }
                    DispatchQueue.main.sync {
                            configuration.data = result
                    }
                    
                }
            }
            catch {
                debugPrint(error)
            }
            
        }
        task.resume()
    }
    
    func pushTsOnRoute(ts: RouteStruct.Data.Ts, type: TypeTransport) -> Station?{
        if(ts.stop_current != nil){
            return Station(id: ts.stop_current!, name: "", stationState: .someStation, pictureTs: getPictureTransport(type: type), time: "")
        }
        if(ts.stop_next != nil){
            return Station(id: ts.stop_next!, name: "", stationState: .someStation, pictureTs: getPictureTransport(type: type), time: "1 мин", isNext: true)
        }
        return nil
    }
    
    func getPictureTransport(type: TypeTransport) -> String {
        switch type {
        case .bus:
            return "bus"
        case .train:
            return "tram"
        case .trolleybus:
            return "bus.doubledecker"
        case .countryBus:
            return "bus.fill"
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
