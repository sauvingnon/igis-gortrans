//
//  LabelOfTransportUnit.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 15.12.2023.
//

import SwiftUI

struct LabelOfTransportUnit: View {
    
    @Binding var transportUnitDescription: String
    
    var handlerFunc: ()->()
    
    var body: some View {
        Button(action: {
            handlerFunc()
        }, label: {
            HStack{
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                VStack{
                    Text(transportUnitDescription)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
            }
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.top, 10)
        })
    }
}

//#Preview {
//    
//    @State var desc = "АВТОБУС - А658РИ"
//    
//    var body: any View{
//        LabelOfTransportUnit(transportUnitDescription: $desc, handlerFunc: {
//            
//        })
//    }
//}
