//
//  NotificationsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import SwiftUI

struct NotificationsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @ObservedObject var chatModel = ChatModel.shared
    
    var body: some View {
        VStack{
            notificationsLabel(handlerDelete: deleteTapped)
            
            if(chatModel.realTimeMessages.count != 0){
                ChatView(chatModel: chatModel)
            }else{
                Spacer()
                Image("empty_notifications")
                Text("Уведомлений нет")
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    .kerning(2)
                    .minimumScaleFactor(0.01)
                Spacer()
            }
            
            
        }
//        .onTapGesture {
//            chatModel.sendMessage(currentMessage: Message(title: "Автобус №29 гос. номер Е456ТМ18", content: "Ваш транспорт скоро прибудет на ост. \"Аврора\"", dateTime: DateTime.init()))
//        }
    }
    
    func deleteTapped(){
        chatModel.removeAllMessages()
        print("Уведомления удалены")
    }
}

//struct NotificationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationsView()
//    }
//}

extension NotificationsView{
    func notificationsLabel(handlerDelete: @escaping () -> ()) -> some View{
        VStack{
            HStack{
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(.blue)
                    .padding(.trailing, 30)
                    .offset(y: 27)
                    .onTapGesture {
                        handlerDelete()
                    }
            }
            Text("Уведомления")
                .font(.system(size: 25))
                .fontWeight(.light)
                .kerning(1.5)
                .foregroundColor(.blue)
            GeometryReader{ geometry in
                
            }
            .frame(height: 1)
            .background(Color.blue)
            .padding(.horizontal, 30)
            .offset(y: -13)
        }
    }
}
