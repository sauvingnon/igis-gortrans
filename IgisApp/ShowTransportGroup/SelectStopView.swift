//
//  SelectStopView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct SelectStopView: View {
    
    @EnvironmentObject var navigation: NavigationTransport
    
    var body: some View {
        VStack{
            labelIzhevsk(withBackButton: true)
                .onTapGesture {
                    navigation.state = .chooseRouteOrStation
                }
            
            ScrollView{
                Grid(alignment: .leading){
                    ForEach(DataBase.getArrayStopsInt(), id: \.self) { item in
                            GridRow{
                                Text(DataBase.stops[item] ?? "Error")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20))
                                    .kerning(2)
                                    .offset(y: 17)
                                    .padding(.bottom, 5)
                            }
                    }
                }
            }.scrollIndicators(.hidden)
            
            Spacer()
        }
    }
}

struct SelectStopView_Previews: PreviewProvider {
    static var previews: some View {
        SelectStopView()
    }
}
