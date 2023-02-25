//
//  FavoritesGroupSelector.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.02.2023.
//

import SwiftUI

struct FavoritesGroupSelector: View {
    
    @StateObject var favorites = Favorites()
    @StateObject var currentView = currentFavoritesViewClass()
    
    var body: some View {
        ZStack{
            switch currentView.state{
            case .favorites:
                currentView.favoritesView
            case .showTransport:
                currentView.favoriteTransport
            case .showStop:
                currentView.favoriteStop
            }
        }
        .environmentObject(favorites)
        .environmentObject(currentView)
    }
}

struct FavoritesGroupSelector_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesGroupSelector()
    }
}

class currentFavoritesViewClass: ObservableObject{
    @Published var state: CurrentFavoritesSelectionView = .favorites
    let favoritesView = FavoritesView()
    let favoriteStop = FavoriteStopOnline()
    let favoriteTransport = FavoriteTransportOnline()
}

enum CurrentFavoritesSelectionView{
    case favorites
    case showTransport
    case showStop
}
