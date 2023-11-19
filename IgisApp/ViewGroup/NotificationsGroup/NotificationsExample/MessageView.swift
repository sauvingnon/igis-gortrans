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
        MessageView(currentMessage: Message(title: "Автобус №29 гос. номер Е456ТМ18", content: "Ваш транспорт скоро прибудет на ост. \"Аврора\".", dateTime: DateTime()))
    }
}

struct Message: Hashable, Codable {
    var title: String
    var content: String
    var time: String
    init(title: String, content: String, dateTime: DateTime) {
        self.title = title
        self.content = content
        self.time = dateTime.time
    }
}
