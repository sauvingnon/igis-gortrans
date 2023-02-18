//
//  SelectNumTSView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import SwiftUI

struct SelectTransportNumber: View {
    
    @EnvironmentObject var currentView: currentViewClass
    
    @ObservedObject var currentChoose = CurrentChoose()
    
    @State var currentIntBas = 22
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(){
            labelIzhevsk()
                .onTapGesture {
                    currentView.state = .chooseTypeTransport
                }
            labelTypeTransport(typeTransport: currentChoose.transportType)
                
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(currentChoose.transportNumArray, id: \.self){ number in
                    Button(action: {
                        let routeId = Model.getRouteId(type: currentChoose.transportType, number: number)
                        currentView.showTransportOnline.updateRouteData(routeId: routeId, type: currentChoose.transportType, number: number)
                        currentView.state = .showTransportOnline
                    }){
                        Text(String(number))
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
                    currentView.state = .chooseTypeTransport
                }
            }))
        
        
    }
    
    func setSettings(type: TypeTransport, numbers: [Int]){
        currentChoose.transportType = type
        currentChoose.transportNumArray = numbers
    }
    
}

struct SelectNumTSView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTransportNumber()
    }
}

class CurrentChoose: ObservableObject{
    @Published var transportNumArray: [Int] = []
    @Published var transportType: TypeTransport = .bus
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
                    .minimumScaleFactor(0.01)
                GeometryReader{ geometry in
                    
                }
                .frame(height: 2)
                .background(Color.blue)
                .padding(.horizontal, 20)})
    }
}
