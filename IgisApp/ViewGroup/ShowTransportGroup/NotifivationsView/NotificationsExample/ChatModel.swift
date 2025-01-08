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
    
    func notificationAccessIsGrantedSync() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var isGranted: Bool = false

        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Доступ к уведомлениям разрешен")
                isGranted = true
            case .denied:
                print("Доступ к уведомлениям запрещен")
                isGranted = false
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        print("Ошибка при запросе доступа к уведомлениям: (error.localizedDescription)")
                        isGranted = false
                    } else {
                        isGranted = granted
                        if granted {
                            print("Доступ к уведомлениям разрешен")
                        } else {
                            print("Доступ к уведомлениям запрещен")
                        }
                    }
                    semaphore.signal() // Сигнализируем о завершении асинхронной операции
                }
                return // Возвращаемся, чтобы не продолжать выполнение кода
            case .provisional:
                print("Предоставлен временный доступ к уведомлениям.")
                isGranted = true
            case .ephemeral:
                print("Эпhemeral доступ к уведомлениям.")
                isGranted = true
            @unknown default:
                print("Неизвестный статус доступа к уведомлениям.")
                isGranted = false
            }
            
            semaphore.signal() // Сигнализируем о завершении асинхронной операции
        }

        // Ожидаем завершения асинхронной операции
        semaphore.wait()
        
        return isGranted
    }
    
    func requestNotificationAccess() {
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
               if let error = error {
                   print("Ошибка при запросе доступа к уведомлениям: (error.localizedDescription)")
               } else if granted {
                   print("Доступ к уведомлениям разрешен")
               } else {
                   print("Доступ к уведомлениям запрещен")
               }
           }
       }

    
    func sendMessage(currentMessage: Message, countTime: Double) {
        
        FireBaseService.shared.notificationWasUsed(text: currentMessage.content)
        
        saveMessage(message: currentMessage)
        requestNotificationAccess()
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
