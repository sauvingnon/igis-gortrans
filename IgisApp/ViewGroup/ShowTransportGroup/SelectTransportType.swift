//
//  SelectTransportType.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

struct SelectTransportType: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentTransportSelectionView]

    var body: some View {
        VStack(){
            labelIzhevsk(withBackButton: true)
                .onTapGesture {
                    dismiss()
                }
            HStack(){
                Button {
                    ChooseTransportRouteViewModel.configureView(type: .bus)
                    navigationStack.append(.chooseNumberTransport)
                } label: {
                    VStack(){
                        Image(systemName: "bus") .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Автобусы")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                Button {
                    ChooseTransportRouteViewModel.configureView(type: .trolleybus)
                    navigationStack.append(.chooseNumberTransport)
                } label: {
                    VStack(){
                        Image(systemName: "bus.doubledecker") .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Троллейбусы")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
            }
            .padding(.top, 30)
            
            HStack(){
                Button {
                    ChooseTransportRouteViewModel.configureView(type: .train)
                    navigationStack.append(.chooseNumberTransport)
                } label: {
                    VStack(){
                        Image(systemName: "tram") .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Трамваи")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                
                Button {
                    ChooseTransportRouteViewModel.configureView(type: .countrybus)
                    navigationStack.append(.chooseNumberTransport)
                } label: {
                    VStack(){
                        Image(systemName: "bus.fill") .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Пригородные автобусы")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
            }
            Spacer()
        }
        .gesture(DragGesture(minimumDistance: 40, coordinateSpace: .local)
            .onEnded({ value in
                if  value.translation.width > 0{
                    dismiss()
                }
            }))
    }
}

//struct SelectTransportType_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectTransportType()
//    }
//}
