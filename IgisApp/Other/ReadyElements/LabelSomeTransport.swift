//
//  LabelSomeTransport.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import Foundation
import SwiftUI

struct LabelSomeTransport: View {
    @State var name: String
    @Binding var isFavorite: Bool
    @State private var sizeStar = 1.0
    var backTapp: ()->()
    var starTapp: ()->()
    var body: some View {
        HStack{
            Image(systemName: "chevron.left")
                .font(.system(size: 25))
                .padding(.leading, 20)
                .foregroundColor(.white)
            Text(name)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .fontWeight(.medium)
            Spacer()
            Image(systemName: "star.fill")
                .frame(width: 50, height: 50)
                .foregroundColor(isFavorite ? .orange : .white)
                .fontWeight(.black)
                .scaleEffect(sizeStar)
                .onTapGesture{
                    // Добавление маршрута в избранное или удаление
                    sizeStar = 0.5
                    withAnimation(.spring()) {
                        starTapp()
                        Vibration.medium.vibrate()
                        sizeStar = 1.0
                    }
                }
        }
        .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
        .background(Color.blue)
        .clipShape(Rectangle())
        .cornerRadius(25)
        .padding(.top, 10)
        .onTapGesture{
            backTapp()
        }
    }
}
