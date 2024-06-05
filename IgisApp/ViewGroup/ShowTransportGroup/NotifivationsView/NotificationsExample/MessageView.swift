//
//  ContentMessageView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import SwiftUI

struct MessageView: View {
    var currentMessage: Message
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            VStack{
                Text(currentMessage.title)
                    .fontWeight(.bold)
                Text(currentMessage.content)
                    .multilineTextAlignment(.leading)
                HStack{
                    Spacer()
                    Text(currentMessage.time)
                }
            }
            .frame(width: UIScreen.screenWidth - 60)
            .padding(10)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(25)
        }
        
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(currentMessage: Message(date: Date(), title: "Автобус №29 гос. номер Е456ТМ18", content: "Ваш транспорт скоро прибудет на ост. \"Аврора\".", time: "19:30"))
    }
}

struct Message: Hashable, Codable {
    let date: Date
    let title: String
    let content: String
    let time: String
}
