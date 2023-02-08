//
//  SelectNumTSView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import SwiftUI

struct SelectTransportNumber: View {
    
    @Binding var currentView: CurrentTransportViewType
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let transportNumArray: [Int]
    
    var body: some View {
        VStack(){
            labelIzhevsk()
                .onTapGesture {
                    currentView = .chooseTypeTransport
                }
            labelTypeTransport(typeTransport: .bus)
                
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(transportNumArray, id: \.self){ bus in
                    Button(action: {
                        
                    }){
                        Text(String(bus))
                            .font(.system(size: 25))
                            .fontWeight(.black)
                            .frame(width: 65, height: 65)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
            }.padding(20)
            
            Spacer()
        }
        .gesture(DragGesture(minimumDistance: 40, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width > 0{
                    currentView = .chooseTypeTransport
                }
            }))
        
        
    }
    
    private func getTSArray(){
        
    }
}

struct SelectNumTSView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTransportNumber(currentView: .constant(.chooseTypeTransport), transportNumArray: Model.busArray)
    }
}

extension SelectTransportNumber{
    func labelTypeTransport(typeTransport: TypeTransport) -> (some View) {
        var nameTransport = ""
        switch typeTransport {
        case .bus: nameTransport = "АВТОБУСЫ"
        case .countryBus: nameTransport = "ПРИГОРОД АВТОБУСЫ"
        case .train: nameTransport = "ТРАМВАИ"
        case .trolleybus: nameTransport = "ТРОЛЛЕЙБУСЫ"
        }
        return(
            VStack(alignment: .leading){
                Text(nameTransport)
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    .kerning(2)
                    .offset(y: 17)
                    .padding(.leading, 20)
                GeometryReader{ geometry in
                    
                }
                .frame(height: 2)
                .background(Color.blue)
                .padding(.horizontal, 20)})
    }
}
