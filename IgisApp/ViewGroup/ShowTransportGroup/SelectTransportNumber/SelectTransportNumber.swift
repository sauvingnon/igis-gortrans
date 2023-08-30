//
//  SelectNumTSView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import SwiftUI

struct SelectTransportNumber: View {
    
    @EnvironmentObject var coordinator: coordinatorTransport
    
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
                    coordinator.show(view: .chooseTypeTransport)
                }
            
            ScrollView(.vertical, showsIndicators: false){
                someTransport(typeTransport: configuration.type, arrayNumbers: configuration.numArray, handlerFunc: chooseHandler(number:type:))
            }
            
            Spacer()
        }
        .gesture(DragGesture(minimumDistance: 40, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width > 0{
                    coordinator.show(view: .chooseTypeTransport)
                }
            }))
        
        
    }
    
    func configureView(type: TypeTransport){
        configuration.numArray = DataBase.getArrayNumbersRoutes(type: type)
        
        // Заглушка от теплоходов
        if(type == .countrybus){
            configuration.type = .bus
        }else{
            configuration.type = type
        }
        
    }
    
    func chooseHandler(number: String, type: TypeTransport){
        let routeId = DataBase.getRouteId(type: type, number: number)
        
        coordinator.showRouteOnline.configureView(routeId: routeId, type: type, number: number)
        
        coordinator.show(view: .showRouteOnline)
    }
    
}

class NumbersViewConfiguration: ObservableObject{
    @Published var numArray: [String] = []
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
        case .countrybus: nameTransport = "ПРИГОРОД АВТОБУСЫ"
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
