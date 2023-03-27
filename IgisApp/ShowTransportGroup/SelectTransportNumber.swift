//
//  SelectNumTSView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import SwiftUI

struct SelectTransportNumber: View {
    
    @EnvironmentObject var navigation: NavigationTransport
    
    @ObservedObject var configuration = NumbersViewConfiguration()
    
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
                    navigation.state = .chooseTypeTransport
                }
            
            someTransport(typeTransport: configuration.type, arrayNumbers: configuration.numArray, handlerFunc: chooseHandler(number:type:))
            
            Spacer()
        }
        .gesture(DragGesture(minimumDistance: 40, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width > 0{
                    navigation.state = .chooseTypeTransport
                }
            }))
        
        
    }
    
    func configureView(type: TypeTransport){
        configuration.numArray = Model.getArrayNum(type: type)
        configuration.type = type
    }
    
    func chooseHandler(number: Int, type: TypeTransport){
        let routeId = Model.getRouteId(type: type, number: number)
        
        navigation.showTransportOnline.configureView(routeId: routeId, type: type, number: number)
        
        navigation.state = .showTransportOnline
    }
    
}

class NumbersViewConfiguration: ObservableObject{
    @Published var numArray: [Int] = []
    @Published var type: TypeTransport = .bus
}

struct SelectNumTSView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTransportNumber()
    }
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
