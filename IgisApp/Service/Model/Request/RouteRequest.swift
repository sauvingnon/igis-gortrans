//
//  RouteRequest.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 12.01.2025.
//


struct RouteRequest: Codable {
    let channel: String
    init(route_number: String, transport_type: TypeTransport) {
        let result = "/izh/\(RouteRequest.getName(transport_type: transport_type))/\(route_number)"
        self.channel = result
    }
    
    private static func getName(transport_type: TypeTransport) -> String {
        switch(transport_type){
        case .bus:
            return "citybus"
        case .train:
            return "tram"
        case .trolleybus:
            return "trolleybus"
        case .countrybus:
            return "suburbanbus"
        }
    }
}