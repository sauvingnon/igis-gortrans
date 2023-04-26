//
//  FavoritesGroupSelector.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.02.2023.
//

import SwiftUI

struct FavoritesGroupSelector: View {
    
    @StateObject var navigator = currentFavoritesViewClass()
    
    var body: some View {
        ZStack{
            switch navigator.state{
            case .favorites:
                navigator.favoritesView
            case .showTransport:
                navigator.favoriteTransport
            case .showStop:
                navigator.favoriteStop
            }
        }
        .environmentObject(navigator)
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
    
    func show(view: CurrentFavoritesSelectionView){
        withAnimation(.easeIn(duration: 0.2)){
            state = view
        }
    }
}

enum CurrentFavoritesSelectionView{
    case favorites
    case showTransport
    case showStop
}
