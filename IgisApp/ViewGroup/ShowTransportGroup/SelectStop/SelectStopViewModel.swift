//
//  SelectStopViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 24.11.2023.
//

import Foundation

class SelectStopViewModel{
    
    static let shared = SelectStopViewModel()
    private init(){
        
    }
    
    func fillStopList(searchText: String) -> [StopItem]{
        var stops = DataBase.getAllStops()
        let text = searchText.lowercased()
        var result: [StopItem] = []
        
        if(!text.isEmpty){
            stops = stops.filter { item in
                item.stop_name?.lowercased().contains(text) ?? false || item.stop_name_abbr?.lowercased().contains(text) ?? false || item.stop_name_short?.lowercased().contains(text) ?? false || item.stop_final_name?.lowercased().contains(text) ?? false
            }
        }
        
        stops.forEach { stopItem in
            
            let stopsType = DataBase.getTypesTransportForStop(stopId: stopItem.stop_id)
            
            result.append(StopItem(stop_id: stopItem.stop_id, typeTransportList: stopsType, stopName: stopItem.stop_name ?? "ошибка", stopDirection: stopItem.stop_direction ?? "ошибка"))
        }
        
        
        
        return result
        
    }
    
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
