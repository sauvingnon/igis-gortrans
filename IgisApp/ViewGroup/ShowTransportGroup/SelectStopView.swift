//
//  SelectStopView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct SelectStopView: View {
    
    @EnvironmentObject var navigation: NavigationTransport
    
    @State var searchText = ""
    
    @State private var scaleBack = 1.0
    
    @FocusState private var searchIsFocuced: Bool
    
    private var columns: [GridItem] = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            labelIzhevsk(withBackButton: true)
                .scaleEffect(scaleBack)
                .onTapGesture {
                    scaleBack = 1.5
                    withAnimation(.spring(dampingFraction: 0.5)){
                        scaleBack = 1.0
                    }
                    navigation.show(view: .chooseRouteOrStation)
                }
            
            TextField("Поиск остановки", text: $searchText)
                .padding(.horizontal, 20)
                .focused($searchIsFocuced)
            
            
            Divider()
                .frame(width: UIScreen.screenWidth - 40, height: 1)
                .background(Color.gray)
            
            ScrollView{
                LazyVGrid(columns: columns, alignment: .leading){
                    ForEach(filterStops(), id: \.self) { item in
                        GridRow{
                            Text("\(item.stop_name ?? "Ошибка"): \(item.stop_direction ?? "Ошибка")")
                                .foregroundColor(.blue)
                                .font(.system(size: 17))
                                .kerning(1)
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                    }
                }
                .animation(.default, value: searchText)
            }
            //            .scrollIndicators(.hidden)
            
        }
        .onTapGesture {
            searchIsFocuced = false
        }
    }
    
    func filterStops() -> [StopsStruct]{
        var stops = DataBase.getAllStops()
        
        if(searchText.isEmpty){
            return stops
        }
        
        stops = stops.filter { item in
            item.stop_name?.contains(searchText) ?? false || item.stop_name_abbr?.contains(searchText) ?? false || item.stop_name_short?.contains(searchText) ?? false || item.stop_final_name?.contains(searchText) ?? false
        }
        
        return stops
    }
}

struct SelectStopView_Previews: PreviewProvider {
    static var previews: some View {
        SelectStopView()
    }
}
