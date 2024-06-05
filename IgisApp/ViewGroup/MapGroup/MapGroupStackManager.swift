//
//  MapGroupStackManager.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 16.03.2024.
//

import Foundation
import SwiftUI

struct MapGroupStackManager: View {
    
    static let shared = MapGroupStackManager()
    
    private init(){
        
    }
    
    private class MapGroupStackManagerModel: ObservableObject {
        @Published var navigationStack = NavigationPath([CurrentTransportSelectionView]())
    }
    
    @ObservedObject private var model = MapGroupStackManagerModel()
    
    var body: some View {
        CustomNavigationStack(path: $model.navigationStack){
            MapView(navigationStack: $model.navigationStack)
                .navigationDestination(for: CurrentTransportSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .chooseRouteOrStation:
                        MapView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showRouteOnline(let routeId):
                        ShowTransportRouteView(navigationStack: $model.navigationStack, routeId: routeId)
                            .navigationBarBackButtonHidden(true)
                    case .showStopOnline(let stopId):
                        ShowTransportStopView(navigationStack: $model.navigationStack, stopId: stopId)
                            .navigationBarBackButtonHidden(true)
                    case .showTransportUnit(let transportId):
                        ShowTransportUnitView(navigationStack: $model.navigationStack, transportId: transportId)
                            .navigationBarBackButtonHidden(true)
                    default:
                        MapView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    }
                }
                .navigationBarBackButtonHidden(true)
        }
    }
    
    // Очистка навигационного стека
    public func clearNavigationStack(){
        model.navigationStack.removeLast(model.navigationStack.count)
    }
}
