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
}
