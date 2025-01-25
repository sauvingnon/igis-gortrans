//
//  RouteResponse.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 12.01.2025.
//


struct RouteResponse: Codable {
    let code: String
    let data: DataObject
    struct DataObject: Codable {
        let notwork: Notwork
        struct Notwork: Codable {
            let code: String
            let description: String
            let network: [Int]
        }
        let scheme: [SchemeObject]
        struct SchemeObject: Codable {
            let sec: Int
            let stop: String
            let time: String?
            let ts: [TsObject]
            struct TsObject: Codable {
                let azimuth: Int
                let finish: FinishObject
                struct FinishObject: Codable {
                    let id: Int
                    let name: String
                }
                let gosnumber: String
                let id: String
                let latlng: [Float64]
                let lowfloor: String
                let reys_status: String
                let route: String
                let ts_type: String
            }
        }
//        let sender: String
//        let type: String
    }
}