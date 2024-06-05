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
            NotificationsLabel(handlerDelete: deleteTapped, handlerBack: backTapped)
            
            if(chatModel.realTimeMessages.count != 0){
                ChatView(chatModel: chatModel)
            }else{
                Spacer()
                Image("empty_notifications")
                Text("Уведомлений нет")
                    .foregroundColor(.blue.opacity(0.6))
                    .font(.system(size: 25))
                    .kerning(2)
                    .minimumScaleFactor(0.01)
                Spacer()
            }
            
            
        }
        .onAppear(){
            chatModel.updateMessages()
        }
//        .onTapGesture {
//            chatModel.sendMessage(currentMessage: Message(title: "Автобус №29 гос. номер Е456ТМ18", content: "Ваш транспорт скоро прибудет на ост. \"Аврора\"", dateTime: DateTime.init()))
//        }
    }
    
    func deleteTapped(){
        withAnimation{
            chatModel.removeAllMessages()
        }
    }
    
    func backTapped(){
        dismiss()
    }
}

//struct NotificationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationsView()
//    }
//}

struct NotificationsLabel: View {
    
    let handlerDelete: () -> ()
    
    let handlerBack: () -> ()
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .foregroundColor(.blue)
                    .onTapGesture {
                        handlerBack()
                    }
                Spacer()
                Text("Уведомления")
                    .font(.system(size: 25))
                    .fontWeight(.light)
                    .kerning(1.5)
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "trash")
                    .font(.system(size: 25))
                    .foregroundColor(.blue)
                    .onTapGesture {
                        handlerDelete()
                    }
            }
            .padding(.horizontal, 20)
            GeometryReader{ geometry in
                
            }
            .frame(height: 1)
            .background(Color.blue)
            .padding(.horizontal, 20)
//            .offset(y: -13)
        }
    }
}
