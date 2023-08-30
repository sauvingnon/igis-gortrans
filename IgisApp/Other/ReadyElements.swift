//
//  ReadyElementsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

// MARK: Перечислены элементы, которые будут многократно использованы сразу в нескольких экранах приложения

extension View{
    // Для надписи Ижевск
    func labelIzhevsk(withBackButton: Bool) -> some View {
        HStack{
            if withBackButton{
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                Text("ИЖЕВСК")
                    .cornerRadius(25)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }else{
                Text("ИЖЕВСК")
                    .padding(.leading, 20)
                    .cornerRadius(25)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }
            
        }
        .frame(width: UIScreen.screenWidth-40, height: 60, alignment: .leading)
        .background(Color.orange)
        .cornerRadius(25)
        .padding(.top, 10)
    }
    
    // Для отобржение массива номеров транспорта одного типа
    func someTransport(typeTransport: TypeTransport, arrayNumbers: [String], handlerFunc: @escaping (String, TypeTransport) -> Void) -> some View {
        VStack{
            labelTypeTransport(typeTransport: typeTransport)
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
                            .minimumScaleFactor(0.01    )
                    }
                }
            }.padding(.horizontal, 20)
        }
    }
    
    // Какой либо транспорт или остановка
    func labelSomeTransport(name: String, isFavorite: Bool, backTapp: @escaping ()->(), starTapp: @escaping ()->()) -> some View{
        
        var sizeStar = 1.0
        
        return HStack{
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

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

