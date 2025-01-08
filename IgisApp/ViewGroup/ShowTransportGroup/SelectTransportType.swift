//
//  SelectTransportType.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

struct SelectTransportType: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    var body: some View {
        VStack(){
            LabelIzhevsk(withBackButton: true, stack: $navigationStack)
            {
                dismiss()
            }
            
            HStack(){
                Button {
                    ChooseTransportRouteViewModel.shared.configureView(type: .bus)
                    navigationStack.append(CurrentTransportSelectionView.chooseNumberTransport)
                    
                } label: {
                    VStack(){
                        Image("bus_icon_white")
                            .resizable()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Автобусы")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: calculateSize(), height: calculateSize())
                    .background(.blue)
                    .cornerRadius(15)
                }
                Button {
                    ChooseTransportRouteViewModel.shared.configureView(type: .trolleybus)
                    navigationStack.append(CurrentTransportSelectionView.chooseNumberTransport)
                    
                } label: {
                    VStack(){
                        Image("trolleybus_icon_white")
                            .resizable()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Троллейбусы")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: calculateSize(), height: calculateSize())
                    .background(.blue)
                    .cornerRadius(15)
                }
            }
            .padding(.top, 30)
            
            HStack(){
                Button {
                    ChooseTransportRouteViewModel.shared.configureView(type: .train)
                    navigationStack.append(CurrentTransportSelectionView.chooseNumberTransport)
                    
                } label: {
                    VStack(){
                        Image("train_icon_white")
                            .resizable()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Трамваи")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: calculateSize(), height: calculateSize())
                    .background(.blue)
                    .cornerRadius(15)
                }
                
                Button {
                    ChooseTransportRouteViewModel.shared.configureView(type: .countrybus)
                    navigationStack.append(CurrentTransportSelectionView.chooseNumberTransport)
                    
                } label: {
                    VStack(){
                        Image("bus_icon_white") 
                            .resizable()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Пригородные автобусы")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: calculateSize(), height: calculateSize())
                    .background(.blue)
                    .cornerRadius(15)
                }
            }
            Spacer()
        }
    }
    
    private func calculateSize() -> CGFloat {
        return (UIScreen.screenWidth - 60)/2
    }
    
}

struct SelectTransportType_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        SelectTransportType(navigationStack: $stack)
    }
}
