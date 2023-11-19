//
//  ChooseTransportRouteModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.11.2023.
//

import Foundation

class ChooseTransportRouteModel: ObservableObject{
    static let shared = ChooseTransportRouteModel()
    private init(){
        
    }
    @Published var numArray: [String] = []
    @Published var type: TypeTransport = .bus
}
