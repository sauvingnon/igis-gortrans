//
//  MapViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 31.05.2023.
//

import Foundation
import SwiftUI

class MapViewModel{
    var configuration = MapModel()
    
    func getTransportCoordinate(){
        ServiceSocket.shared.getEverythingData(city: "izh", configuration: self.configuration)
    }
}
