//
//  CustomBackChevron.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 30.01.2024.
//

import SwiftUI

struct CustomBackLabel: View {
    
    var text: String
    var handlerFunc: () -> ()
    
    var body: some View {
        
        Button(action: {
            handlerFunc()
        }, label: {
            HStack(alignment: .top){
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 40)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                Text(text)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 25))
                    .minimumScaleFactor(0.01)
                Spacer()
                
            }
            .padding(.top, 20)
        })
    }
}

#Preview {
    CustomBackLabel(text: "Что такое IGIS:Транспорт?"){
        
    }
}
