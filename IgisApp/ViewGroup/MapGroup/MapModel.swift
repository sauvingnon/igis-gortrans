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
    
    @Published var locations: [CustomAnnotation] = []{
        didSet{
            CustomMap.updateAnnotation()
        }
    }
    @Published var hideBus = false
    @Published var hideTrain = false
    @Published var hideTrolleybus = false
    @Published var useSmallMapItems = false
    @Published var onlyFavoritesTransport = false
    @Published var sheetIsPresented = false
    @Published var routeDescription = "-"
    @Published var routeDirection = "-"
}
