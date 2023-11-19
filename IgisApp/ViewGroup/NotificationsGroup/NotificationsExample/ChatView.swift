//
//  ChatView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject var chatModel: ChatModel
    
    var body: some View {
        VStack {
            ScrollView{
                    ForEach(chatModel.realTimeMessages, id: \.self){ message in
                        MessageView(currentMessage: message)
                    }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    
//    func sendMessage() {
//        chatModel.sendMessage(currentMessage: Message(title: "Автобус №29 гос. номер Е456ТМ18", content: "Ваш транспорт скоро прибудет на ост. \"Аврора\"", dateTime: DateTime.init()))
//    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatModel: ChatModel.shared)
    }
}
