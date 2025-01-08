//
//  DropDownAlert.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.03.2024.
//

import SwiftUI

struct CustomSearchBar: View {
    
    @Binding var isPresent: Bool
    @State private var yMove = 0.0
    @ObservedObject private var model = MapModel.shared
    
    var tapUnit: ()->()
    var tapRoute: ()->()
    
    @State var stringFrom = ""
    @State var stringTo = ""
    
    var body: some View {
        ZStack{
            VStack{
                
                TextField("Откуда", text: $stringFrom)
                
                TextField("Куда", text: $stringTo)
                
                GeometryReader{ geometry in
                    
                }
                .frame(width: 40, height: 4)
                .background(Color.blue)
                .padding(.vertical, 5)
                
            }
            .padding(.horizontal, 20)
        }
        .background(.white)
        .clipShape(.rect(topLeadingRadius: 25, topTrailingRadius: 25))
        .frame(maxHeight: .infinity, alignment: .top)
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

struct CustomSearchBar_Previews: PreviewProvider {
    
    @State static var isPresent = true
    
    static var previews: some View {
        CustomSearchBar(isPresent: $isPresent, tapUnit: {
            
        }, tapRoute: {
            
        })
    }
}
