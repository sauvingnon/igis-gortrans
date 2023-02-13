//
//  ServiceAPI.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 10.02.2023.
//

import Foundation

class ServiceAPI{
    
    func fetchDataForRoute(idRoute: Int){
        
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
    }
    let last_modify: String
    let cache_lifetime: Int
    let copyright: String
    let version: String
}
