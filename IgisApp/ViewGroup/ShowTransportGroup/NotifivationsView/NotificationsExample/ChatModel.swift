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
    
    init(didChange: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()) {
        self.didChange = didChange
        self.realTimeMessages = getMessages()
    }
    
    func updateMessages(){
        realTimeMessages = getMessages()
    }
    
    func sendMessage(currentMessage: Message, countTime: Double) {
        saveMessage(message: currentMessage)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Уведомление зарегестрировано")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "IGIS: Транспорт Ижевска"
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
        UserDefaults.standard.removeObject(forKey: "Messages")
    }
    
    private func getMessages() -> [Message]{
        if let data = UserDefaults.standard.object(forKey: "Messages") as? Data,
           let allMessages = try? JSONDecoder().decode([Message].self, from: data) {
            
            let fillter = allMessages.filter { message in
                message.date <= Date()
            }
            
            return fillter
        }
        return []
    }
    
    private func saveMessage(message: Message){
        
        if let data = UserDefaults.standard.object(forKey: "Messages") as? Data, var allMessages = try? JSONDecoder().decode([Message].self, from: data) {
            
            allMessages.append(message)
            
            if let encoded = try? JSONEncoder().encode(allMessages) {
                UserDefaults.standard.set(encoded, forKey: "Messages")
            }
        }else{
            var newArray: [Message] = []
            newArray.append(message)
            if let encoded = try? JSONEncoder().encode(newArray) {
                UserDefaults.standard.set(encoded, forKey: "Messages")
            }
        }
    }
    
}
