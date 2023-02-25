//
//  SelectNumTSView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import SwiftUI

struct SelectTransportNumber: View {
    
    @EnvironmentObject var currentView: currentTransportViewClass
    
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
            labelIzhevsk(withBackButton: true)
                .onTapGesture {
                    currentView.state = .chooseTypeTransport
                }
            
            someTransport(typeTransport: currentChoose.transportType, arrayNumbers: currentChoose.transportNumArray, handlerFunc: chooseHandler(number:type:))
            
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
    
    func chooseHandler(number: Int, type: TypeTransport){
        let routeId = Model.getRouteId(type: currentChoose.transportType, number: number)
        currentView.showTransportOnline.updateRouteData(routeId: routeId, type: currentChoose.transportType, number: number)
        
        currentView.state = .showTransportOnline
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

extension View{
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
