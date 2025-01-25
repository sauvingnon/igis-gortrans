//
//  UnitResponse.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 12.01.2025.
//


struct UnitResponse: Codable {
    let code: String
    let data: DataObject
    struct DataObject: Codable {
        let azimuth: Int
//        let event_description: [Any]
        let gosnumber: String
        let latlng: [Float64]
        let main: Int
        let price: PriceObject
        struct PriceObject: Codable {
            let action: String?
            let action_price: Int?
            let bank_card: Int?
            let card: Int?
            let cash: Int?
        }
        let reys_status: String
        let route: String
        let time_reys: String
        let ts_stops: [TsStopsObject]
        struct TsStopsObject: Codable {
            let demand: Int
            let finish: Int
            let id: Int
            let latlng: [Float64]
            let name: String
            let prediction: DynamicValue
        }
        let ts_type: String
    }
}
