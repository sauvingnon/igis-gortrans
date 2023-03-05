//
//  FavoritesView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.02.2023.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var currentView: currentFavoritesViewClass
    
    @ObservedObject var favorites = Favorites()
    
    init(){
        Model.favoritesView = self
    }
    
    var body: some View {
        VStack{
            labelIzhevsk(withBackButton: false)
            ScrollView(.vertical, showsIndicators: false){
                if favorites.items.count == 0 {
                    VStack(alignment: .center){
                        Text("Избранных нет")
                            .foregroundColor(.blue)
                            .font(.system(size: 25))
                            .kerning(2)
                            .minimumScaleFactor(0.01)
                    }
                    .frame(minHeight: UIScreen.screenHeight-250)
                    
                }else{
                    HStack{
                        Text("МОИ МАРШРУТЫ")
                            .foregroundColor(.blue)
                            .font(.system(size: 25))
                            .kerning(2)
                            .padding(.leading, 20)
                            .minimumScaleFactor(0.01)
                            .offset(x: 5)
                        Spacer()
                    }
                }
                ForEach(favorites.items){ item in
                    someTransport(typeTransport: item.type, arrayNumbers: item.numbers, handlerFunc: favoriteRouteTapped(number:type:))
                }
                Spacer()
                
            }
        }
        .frame(width: UIScreen.screenWidth)
    }
    
    func favoriteRouteTapped(number: Int, type: TypeTransport){
        let routeId = Model.getRouteId(type: type, number: number)
        currentView.favoriteTransport.updateRouteData(routeId: routeId, type: type, number: number)
        
        currentView.state = .showTransport
    }
    
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

class Favorites: ObservableObject{
    @Published var items: [FavoriteRoute]
    class FavoriteRoute: Identifiable{
        var id = UUID()
        var type: TypeTransport = .trolleybus
        var numbers: [Int] = []
        init(id: UUID = UUID(), type: TypeTransport, numbers: [Int]) {
            self.id = id
            self.type = type
            self.numbers = numbers
        }
    }
    init() {
        self.items = Model.getFavoriteData()
    }
}



