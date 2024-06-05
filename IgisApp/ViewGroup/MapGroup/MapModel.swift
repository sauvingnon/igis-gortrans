//
//  MapModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 31.05.2023.
//

import Foundation
import MapKit
import SwiftUI

class MapModel: ObservableObject{
    
    public static let shared = MapModel()
    
    private init(){
        
    }
    
    @Published private var stopAnnotations_private: [StopAnnotation]?
    
    var stopAnnotations: [StopAnnotation]{
        get{
            if let annotations = stopAnnotations_private{
                return annotations
            }
            
            stopAnnotations_private = DataBase.getStopAnnotations()
            return stopAnnotations_private!
        }
    }
    
    @Published var transportAnnotations: [TransportAnnotation] = []{
        didSet{
            CustomMap.updateTransportAnnotation()
        }
    }
    @Published var hideBus = false
    @Published var hideTrain = false
    @Published var hideTrolleybus = false
    @Published var hideCountrybus = false
    @Published var useSmallMapItems = false
    @Published var onlyFavoritesTransport = false
    
    @Published var sheetIsPresented = false{
        didSet{
            if(!sheetIsPresented){
                if let annotation = selectedTransportAnnotation{
                    CustomMap.deselectAnnotation(annotation: annotation)
                    MapViewModel.shared.reloadMap()
                    CustomMap.removeStopsAnnotation(stopAnnotations: MapModel.shared.stopAnnotations)
                    selectedTransportAnnotation = nil
                }
                if let annotation = selectedStopAnnotation{
                    CustomMap.deselectAnnotation(annotation: annotation)
                }
            }
        }
    }
    @Published var mainText = "—"
    @Published var thirdText = ""
    @Published var secondText = ""
    var selectedTransportAnnotation: TransportAnnotation?
    var selectedStopAnnotation: StopAnnotation?
    
    var alertAlreadyShow = false
}
