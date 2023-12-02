//
//  FavoriteStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.02.2023.
//

import SwiftUI

struct FavoriteStopOnline: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentFavoritesSelectionView]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct FavoriteStopOnline_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteStopOnline()
//    }
//}
