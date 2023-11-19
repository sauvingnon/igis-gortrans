//
//  SelectNumTSView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import SwiftUI

struct ChooseTransportRouteView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentTransportSelectionView]
    
    @ObservedObject var configuration = ChooseTransportRouteModel.shared
    
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
                    dismiss()
                }
            
            ScrollView(.vertical, showsIndicators: false){
                someTransport(typeTransport: configuration.type, arrayNumbers: configuration.numArray, handlerFunc: chooseHandler(number:type:))
            }
            
            Spacer()
        }
        .gesture(DragGesture(minimumDistance: 40, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width > 0{
                    dismiss()
                }
            }))
        
        
    }
    
    func chooseHandler(number: String, type: TypeTransport){
        let routeId = DataBase.getRouteId(type: type, number: number)
        ShowTransportRouteViewModel.shared.configureView(routeId: routeId, type: type, number: number)
        navigationStack.append(.showRouteOnline)
    }
    
}

//struct SelectNumTSView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectTransportNumber()
//    }
//}

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
