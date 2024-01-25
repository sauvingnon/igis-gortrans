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
        fillStopList(searchText: "")
    }
    
    private let model = SelectStopModel.shared
    
    func fillStopList(searchText: String){
        var stops = DataBase.getAllStops()
        let text = searchText.lowercased()
        
        if(!text.isEmpty){
            stops = stops.filter { item in
                item.stop_name?.lowercased().contains(text) ?? false || item.stop_name_abbr?.lowercased().contains(text) ?? false || item.stop_name_short?.lowercased().contains(text) ?? false || item.stop_final_name?.lowercased().contains(text) ?? false
            }
        }
        
        stops.forEach { stopItem in
            
            let stopsType = DataBase.getTypesTransportForStop(stopId: stopItem.stop_id)
            
            model.stopsList.append(StopItem(stop_id: stopItem.stop_id, typeTransportList: stopsType, stopName: stopItem.stop_name ?? "ошибка", stopDirection: stopItem.stop_direction ?? "ошибка"))
        }
        
    }
    
}
