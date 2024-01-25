//
//  SelectStopModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 24.11.2023.
//

import Foundation

class SelectStopModel: ObservableObject {
    
    static let shared = SelectStopModel()
    private init(){
        
    }
    
    @Published var stopsList: [StopItem] = []
}

struct StopItem: Identifiable{
    let id = UUID()
    let stop_id: Int
    let typeTransportList: [TypeTransport]
    let stopName: String
    let stopDirection: String
    let distance: Int?
    
    init(stop_id: Int, typeTransportList: [TypeTransport], stopName: String, stopDirection: String, distance: Int? = nil) {
        self.stop_id = stop_id
        self.typeTransportList = typeTransportList
        self.stopName = stopName
        self.stopDirection = stopDirection
        
        if var distanceValue = distance{
            // Округлим значение метров до +-5
            let diff = distanceValue % 5
            distanceValue -= diff
            self.distance = distanceValue
        }else{
            self.distance = nil
        }
        
    }
}
