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
    
    var tapUnit: ()->()
    var tapRoute: ()->()
    
    var body: some View {
        ZStack{
            VStack{
                GeometryReader{ geometry in
                    
                }
                .frame(width: 40, height: 4)
                .background(Color.blue)
                .padding(.vertical, 5)
                
                HStack{
                    Text(model.mainText)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        isPresent.toggle()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                }
                
                HStack{
                    Text(model.secondText)
                    Spacer()
                    
                }
                
                HStack{
                    Text(model.thirdText)
                    Spacer()
                }
                
//                if(model.inPark){
//                    HStack{
//                        Spacer()
//                        Text("В парк/депо")
//                            .padding(3)
//                            .bold()
//                            .foregroundStyle(.white)
//                            .background(.red)
//                            .cornerRadius(10)
//                    }
//                }
                
                HStack(alignment: .center){
                    Spacer()
                    Button(action: {
                        tapUnit()
                    }, label: {
                        Text("Подробнее")
                            .padding(7)
                            .bold()
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(10)
                    })
                    Spacer()
                    if(model.selectedStopAnnotation == nil){
                        Button(action: {
                            tapRoute()
                        }, label: {
                            Text("Маршрут")
                                .padding(7)
                                .bold()
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(10)
                        })
                        Spacer()
                    }
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
        DropDownAlert(isPresent: $isPresent, tapUnit: {
            
        }, tapRoute: {
            
        })
    }
}
