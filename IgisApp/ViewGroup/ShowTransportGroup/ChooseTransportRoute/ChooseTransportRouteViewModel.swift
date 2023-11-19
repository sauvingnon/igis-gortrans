//
//  ChooseTransportRouteViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.11.2023.
//

import Foundation

class ChooseTransportRouteViewModel {
    static func configureView(type: TypeTransport){
        ChooseTransportRouteModel.shared.numArray = DataBase.getArrayNumbersRoutes(type: type)
        
        // Заглушка от теплоходов
        if(type == .countrybus){
            ChooseTransportRouteModel.shared.type = .bus
        }else{
            ChooseTransportRouteModel.shared.type = type
        }
    }
}
