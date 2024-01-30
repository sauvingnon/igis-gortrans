//
//  settingsButton.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 30.01.2024.
//

import SwiftUI

struct SettingsButton: View {
    
    var imageName: String
    var text: String
    @State private var sizeStar = 1.0
    
    var handlerFunc: () -> ()
    
    var body: some View {
        Button(action: {
            sizeStar = 0.5
            withAnimation(.spring(dampingFraction: 0.5)) {
                sizeStar = 1.0
            }
            handlerFunc()
        }, label: {
            HStack{
                Image(systemName: imageName)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .padding(.leading, 10)
                Text(text)
                    .fixedSize()
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 18))
                    .padding(.leading, 10)
                    .kerning(0.7)
                Spacer()
                    
            }
            .frame(width: UIScreen.screenWidth-40)
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(15)
        })
        .scaleEffect(sizeStar)
    }
}

#Preview {
    SettingsButton(imageName: "app.badge", text: "Изменить иконку"){
        
    }
    .padding(20)
    .background(.blue)
}
