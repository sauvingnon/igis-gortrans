//
//  FavoritesGroupSelector.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.02.2023.
//

import SwiftUI

struct FavoritesGroupStackManager: View {
    
    static let shared = FavoritesGroupStackManager()
    
    private init(){
        
    }
    
    private class FavoritesGroupStackManagerModel: ObservableObject {
        @Published var navigationStack = NavigationPath([CurrentTransportSelectionView]())
    }
    
    @ObservedObject private var model = FavoritesGroupStackManagerModel()
    
    var body: some View {
        NavigationStack(path: $model.navigationStack){
            FavoriteRoutesAndStopsView(navigationStack: $model.navigationStack)
                .navigationDestination(for: CurrentTransportSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .showFavoriteItems:
                        FavoriteRoutesAndStopsView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showStopOnline(let stopId):
                        ShowTransportStopView(navigationStack: $model.navigationStack, stopId: stopId)
                            .navigationBarBackButtonHidden(true)
                    case .showRouteOnline(let routeId):
                        ShowTransportRouteView(navigationStack: $model.navigationStack, routeId: routeId)
                            .navigationBarBackButtonHidden(true)
                    case .showTransportUnit(let transportId):
                        ShowTransportUnitView(navigationStack: $model.navigationStack, transportId: transportId)
                            .navigationBarBackButtonHidden(true)
                    case .QRScanner:
                        ScannerView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .notifications:
                        NotificationsView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    default:
                        FavoriteRoutesAndStopsView(navigationStack: $model.navigationStack)
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

struct FavoritesGroupSelector_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesGroupStackManager.shared
    }
}
