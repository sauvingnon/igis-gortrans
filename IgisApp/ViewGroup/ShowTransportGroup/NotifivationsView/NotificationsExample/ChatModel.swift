//
//  ChatHelper.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import Foundation
import Combine
import UserNotifications

public class ChatModel : ObservableObject {
    @Published var didChange = PassthroughSubject<Void, Never>()
    @Published var realTimeMessages: [Message] = []
    
    public static let shared = ChatModel()
    
    private init(didChange: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()) {
        self.didChange = didChange
        realTimeMessages = getMessages()
    }
    
    func sendMessage(currentMessage: Message, countTime: Double) {
        realTimeMessages.append(currentMessage)
        didChange.send(())
        saveMessage(messages: realTimeMessages)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "IGIS:Транспорт Ижевска"
        content.subtitle = currentMessage.title
        content.body = currentMessage.content
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: countTime, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeAllMessages(){
        realTimeMessages.removeAll()
        didChange.send(())
        saveMessage(messages: realTimeMessages)
    }
    
    private func getMessages() -> [Message]{
        if let data = UserDefaults.standard.object(forKey: "Messages") as? Data,
           let allMessages = try? JSONDecoder().decode([Message].self, from: data) {
             return allMessages
        }
        return []
    }
    
    private func saveMessage(messages: [Message]){
        if let encoded = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(encoded, forKey: "Messages")
        }
    }
    
}
