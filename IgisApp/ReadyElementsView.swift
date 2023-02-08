//
//  ReadyElementsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

// MARK: Перечилены элементы, которые будут многократно использованы сразу в нескольких экранах приложения

extension View{
    func labelIzhevsk() -> some View {
        GeometryReader(){ geo in
            Text("ИЖЕВСК")
                .padding(.leading, 30)
                .frame(width: geo.size.width, height: 60, alignment: .leading)
                .background(Color.orange)
                .clipShape(Rectangle())
                .cornerRadius(25)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 20.0)
        .padding(.top, 10)
        .frame(height: 60.0)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

