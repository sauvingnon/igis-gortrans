//
//  SomeTransport.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import SwiftUI

struct TableOfRouteWithType: View {
    var typeTransport: TypeTransport
    var arrayNumbers: [String]
    var handlerFunc: (String, TypeTransport) -> ()
    var body: some View {
        VStack{
            LabelTypeTransport(typeTransport: typeTransport)
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20){
                ForEach(arrayNumbers, id: \.self){ number in
                    Button(action: {
                        handlerFunc(number, typeTransport)
                    }){
                        Text(number)
                            .font(.system(size: 25))
                            .fontWeight(.black)
                            .frame(width: 65, height: 65)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .minimumScaleFactor(0.01)
                    }
                }
            }.padding(.horizontal, 20)
        }
    }
}

#Preview {
    TableOfRouteWithType(typeTransport: .bus, arrayNumbers: ["25","22","36"], handlerFunc: { _, _ in

    })
}
