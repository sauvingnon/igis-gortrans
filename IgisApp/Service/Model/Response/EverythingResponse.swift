//
//  EverythingResponse.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 12.01.2025.
//


struct EverythingResponse: Codable{
    let type: String
    let code: String
    let data: [DataObject]
    struct DataObject: Codable{
        let azimuth: Int
        let carrier: String
        let event: String?
        let gosnumber: String
        let id: String
        let inpark: Int
        let latlng: [Float64]
        // 0 - широта, 1 - долгота
        let lowfloor: String
        let main: Int
        let reys_status: String
        let route: String
        let sec: Int
        let stop: StopObject
        struct StopObject: Codable{
            let previous: Int?
            let current: Int?
            let next: Int?
            let finish: FinishObject
            struct FinishObject: Codable{
                let id: Int
                let name: String
            }
            
        }
        let ts_type: String
        let visible: Int
    }
}