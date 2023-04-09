//
//  SelectStopView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct SelectStopView: View {
    
    @EnvironmentObject var navigation: NavigationTransport
    
    @State var scaleBack = 1.0
    
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
            
            ScrollView{
                LazyVGrid(columns: columns, alignment: .leading){
                    ForEach(DataBase.getAllStops(), id: \.self) { item in
                            GridRow{
                                Text("\(item.stop_name_abbr ?? "Ошибка"): \(item.stop_direction ?? "Ошибка")")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 17))
                                    .kerning(1)
                            }
                            .padding(.bottom, 10)
                            .padding(.horizontal, 20)
                    }
                }
            }
//            .scrollIndicators(.hidden)
            
            
        }
    }
}

struct SelectStopView_Previews: PreviewProvider {
    static var previews: some View {
        SelectStopView()
    }
}
