//
//  SelectStopView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct SelectStopView: View {
    
    @EnvironmentObject var currentView: currentTransportViewClass
    
    var body: some View {
        VStack{
            labelIzhevsk(withBackButton: true)
                .onTapGesture {
                    currentView.state = .chooseRouteOrStation
                }
            
            ScrollView{
                Grid(alignment: .leading){
                    ForEach(SomeInfo.getArrayStopsInt(), id: \.self) { item in
                            GridRow{
                                Text(SomeInfo.stops[item] ?? "Error")
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
