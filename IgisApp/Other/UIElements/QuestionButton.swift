//
//  QuestionButton.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 30.01.2024.
//

import SwiftUI

struct QuestionButton: View {
    
    var text: String
    
    @State private var scale = 1.0
    let handlerFunc: () -> ()
    
    var body: some View {
        Button(action: {
            scale = 0.5
            withAnimation(.spring(dampingFraction: 0.5)) {
                scale = 1.0
            }
            handlerFunc()
        }, label: {
            HStack{
                Text(text)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 15))
                    .padding(.leading, 10)
                    .kerning(0.7)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                Spacer()
                    
            }
            .frame(width: UIScreen.screenWidth-40)
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color(red: 0.629, green: 0.803, blue: 1), radius: 10)
        })
        .scaleEffect(scale)
    }
}

#Preview {
    QuestionButton(text: DataBase.title1){
        
    }
}
