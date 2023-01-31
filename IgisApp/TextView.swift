//
//  TextView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 31.01.2023.
//

import SwiftUI

struct TextView: View {
    var body: some View {
        Button(action: {
            print("Кнопка нажата")
        }){
            VStack(){
                Image(systemName: "bus") .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50).foregroundColor(Color.white)
                Text("Автобусы")
                    .foregroundColor(Color.white)
            }
            .padding(.all, 75)
            .background(Color.blue)
            .cornerRadius(15)
        }
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
