//
//  DropDownAlert.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.03.2024.
//

import SwiftUI

struct DropDownAlert: View {
    
    @Binding var isPresent: Bool
    @State private var yMove = 0.0
    @ObservedObject private var model = MapModel.shared
    
    var body: some View {
        ZStack{
            VStack{
                GeometryReader{ geometry in
                    
                }
                .frame(width: 40, height: 4)
                .background(Color.blue)
                .padding(.vertical, 5)
                
                HStack{
                    Text(model.routeDescription)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        isPresent.toggle()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                }
                
                HStack{
                    Text(model.routeDirection)
                    Spacer()
                    
                }
                
                HStack{
                    Button(action: {
                        
                    }, label: {
                        Text("В избранное")
                    })
                    Button(action: {
                        
                    }, label: {
                        Text("Это ТС")
                    })
                    Button(action: {
                        
                    }, label: {
                        Text("Весь маршрут")
                    })
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
        .background(.white)
        .clipShape(.rect(topLeadingRadius: 25, topTrailingRadius: 25))
        .frame(maxHeight: .infinity, alignment: .bottom)
//        .edgesIgnoringSafeArea(.bottom)
        .offset(y: isPresent ? 0 : 300)
        .offset(y: yMove)
        .animation(.default, value: isPresent)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    let difference = gesture.startLocation.y - gesture.location.y
                    if(difference < 0){
                        yMove = abs(difference)
                    }
                }
                .onEnded { _ in
                    if abs(yMove) > 50 {
                        isPresent = false
                        yMove = 0
                    } else {
                        yMove = 0
                    }
                }
        )
    }
}

struct DropDownAlert_Previews: PreviewProvider {
    
    @State static var isPresent = true
    
    static var previews: some View {
        DropDownAlert(isPresent: $isPresent)
    }
}
