//
//  ShowTransportStopModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.11.2023.
//

import Foundation
import SwiftUI

class ShowStopOnlineModel: ObservableObject{
    static let shared = ShowStopOnlineModel()
    private init(){
        
    }
    
    @Published var opacity = 1.0
    @Published var name = "мкрн Нагорный"
    @Published var direction = "В строну ж/д вокзала"
    var stopId = 0
    @Published var isFavorite = false
    @Published var showIndicator = false
    
    @Published private var trains_private: [TransportWaiter] = []
    var trains: [TransportWaiter]{
        get{
            return trains_private
        }
        set{
            trains_private = newValue
            let count = trains_private.count
            if count > 0{
                trains_private[count-1].isLastSection = true
                trains_private[0].isFirstSection = true
            }
        }
    }
    @Published private var buses_private: [TransportWaiter] = []
    var buses: [TransportWaiter]{
        get{
            return buses_private
        }
        set{
            buses_private = newValue
            let count = buses_private.count
            if count > 0{
                buses_private[count-1].isLastSection = true
                buses_private[0].isFirstSection = true
            }
        }
    }
    @Published private var trolleybuses_private: [TransportWaiter] = []
    var trolleybuses: [TransportWaiter]{
        get{
            return trolleybuses_private
        }
        set{
            trolleybuses_private = newValue
            let count = trolleybuses_private.count
            if count > 0{
                trolleybuses_private[count-1].isLastSection = true
                trolleybuses_private[0].isFirstSection = true
            }
        }
    }
    @Published private var countryBuses_private: [TransportWaiter] = []
    var countryBuses: [TransportWaiter]{
        get{
            return countryBuses_private
        }
        set{
            countryBuses_private = newValue
            let count = countryBuses_private.count
            if count > 0{
                countryBuses_private[count-1].isLastSection = true
                countryBuses_private[0].isFirstSection = true
            }
        }
    }
}
