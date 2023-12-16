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
    
    @State private var navigationStack = [CurrentFavoritesSelectionView]()
    
    var body: some View {
        NavigationStack(path: $navigationStack){
            FavoriteRoutesAndStationsView(navigationStack: $navigationStack)
                .navigationDestination(for: CurrentFavoritesSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .favoriteRoutesAndStations:
                        FavoriteRoutesAndStationsView(navigationStack: $navigationStack)
                    case .showFavoriteStop:
                        ShowFavoriteStopView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showFavoriteRoute:
                        ShowFavoriteRouteView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showTransportUnit:
                        ShowFavoriteUnitView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
    
    func navigationStackWillAppear(){
        if let lastView = navigationStack.last{
            switch(lastView){
            case .favoriteRoutesAndStations:
                break
            case .showFavoriteStop:
                ShowFavoriteStopViewModel.shared.getStationData()
                break
            case .showFavoriteRoute:
                ShowFavoriteRouteViewModel.shared.getRouteData()
                break
            case .showTransportUnit:
                ShowTransportUnitViewModel.shared.getTransportData()
                break
            }
        }
    }
}

struct FavoritesGroupSelector_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesGroupStackManager.shared
    }
}

enum CurrentFavoritesSelectionView{
    case favoriteRoutesAndStations
    case showFavoriteRoute
    case showFavoriteStop
    case showTransportUnit
}
