//
//  FavoritesView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.02.2023.
//

import SwiftUI

struct FavoriteRoutesAndStationsView: View {
    
    @Binding var navigationStack: [CurrentFavoritesSelectionView]
    
    @ObservedObject var model = FavoritesRoutesAndStationsModel.shared
    
    var body: some View {
        VStack{
            labelIzhevsk(withBackButton: false)
            ScrollView(.vertical, showsIndicators: false){
                if model.items.count == 0 {
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
                ForEach(model.items){ item in
                    someTransport(typeTransport: item.type, arrayNumbers: item.numbers, handlerFunc: favoriteRouteTapped(number:type:))
                }
                Spacer()
                
            }
        }
        .frame(width: UIScreen.screenWidth)
    }
    
    func favoriteRouteTapped(number: String, type: TypeTransport){
        let routeId = DataBase.getRouteId(type: type, number: number)
        
        FavoriteRouteOnlineModel.configureView(routeId: routeId, type: type, number: number)
        
        navigationStack.append(.showFavoriteRoute)
    }
    
}

//struct FavoritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteRoutesAndStationsView()
//    }
//}

class FavoritesRoutesAndStationsModel: ObservableObject{
    static let shared = FavoritesRoutesAndStationsModel()
    
    private init() {
        self.items = Model.getFavoriteData()
    }
    
    @Published var items: [FavoriteRoute]
    class FavoriteRoute: Identifiable{
        var id = UUID()
        var type: TypeTransport = .trolleybus
        var numbers: [String] = []
        init(id: UUID = UUID(), type: TypeTransport, numbers: [String]) {
            self.id = id
            self.type = type
            self.numbers = numbers
        }
    }
    
}



