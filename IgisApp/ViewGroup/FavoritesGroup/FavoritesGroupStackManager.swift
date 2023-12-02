//
//  FavoritesGroupSelector.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.02.2023.
//

import SwiftUI

struct FavoritesGroupStackManager: View {
    
    @State private var navigationStack = [CurrentFavoritesSelectionView]()
    
    var body: some View {
        NavigationStack(path: $navigationStack){
            FavoriteRoutesAndStationsView(navigationStack: $navigationStack)
                .navigationDestination(for: CurrentFavoritesSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .favoriteRoutesAndStations:
                        FavoriteRoutesAndStationsView(navigationStack: $navigationStack)
                    case .showFavoriteStop:
                        FavoriteStopOnline(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showFavoriteRoute:
                        ShowFavoriteRouteView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
}

struct FavoritesGroupSelector_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesGroupStackManager()
    }
}

enum CurrentFavoritesSelectionView{
    case favoriteRoutesAndStations
    case showFavoriteRoute
    case showFavoriteStop
}
