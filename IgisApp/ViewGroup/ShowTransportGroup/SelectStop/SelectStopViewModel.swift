//
//  SelectStopViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 24.11.2023.
//

import Foundation

class SelectStopViewModel: ObservableObject{
    
    static let shared = SelectStopViewModel()
    private init(){
        fillStopList()
    }
    
    @Published var searchText = ""{
        didSet{
            updateStopList()
        }
    }
    @Published var stops = [StopItem]()
    
    private var stopsConst = [StopItem]()
    
    private func fillStopList(){
        let stops = DataBase.getAllStops()
        var result: [StopItem] = []
        
        stops.forEach { stopItem in
            
            let stopsType = DataBase.getTypesTransportForStop(stopId: stopItem.stop_id)
            
            result.append(StopItem(stop_id: stopItem.stop_id, typeTransportList: stopsType, stopName: stopItem.stop_name ?? "ошибка", stopDirection: stopItem.stop_direction ?? "ошибка", stopNameAbbr: stopItem.stop_name_abbr, stopNameShort: stopItem.stop_name_short, stopFinalName: stopItem.stop_final_name))
        }
        
        stopsConst = result
        self.stops = result
    }
    
    func updateStopList(){
        
        var text = searchText.lowercased()
        text = text.trimmingCharacters(in: .whitespaces)
        
        if(!text.isEmpty){
            stops = stopsConst.filter { item in
                item.stopName.lowercased().contains(text) || item.stopNameAbbr?.lowercased().contains(text) ?? false || item.stopNameShort?.lowercased().contains(text) ?? false || item.stopFinalName?.lowercased().contains(text) ?? false
            }
        }else{
            stops = stopsConst
        }
    }
    
}

struct StopItem: Identifiable{
    let id = UUID()
    let stop_id: Int
    let typeTransportList: [TypeTransport]
    let stopName: String
    let stopDirection: String
    let distance: Int?
    let stopNameAbbr: String?
    let stopNameShort: String?
    let stopFinalName: String?
    
    init(stop_id: Int, typeTransportList: [TypeTransport], stopName: String, stopDirection: String, distance: Int? = nil, stopNameAbbr: String? = nil, stopNameShort: String? = nil, stopFinalName: String? = nil) {
        self.stop_id = stop_id
        self.typeTransportList = typeTransportList
        self.stopName = stopName
        self.stopDirection = stopDirection
        self.stopNameAbbr = stopNameAbbr
        self.stopNameShort = stopNameShort
        self.stopFinalName = stopFinalName
        
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
