//
//  ServiceSocket.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 30.05.2023.
//

import Foundation
import SocketIO
import MessagePacker

class ServiceSocket{
    
    static let shared = ServiceSocket()
    
    static var status: SocketIOStatus{
        get{
            return self.shared.socket.status
        }
    }
    
    private let serverURL = "https://devsocket.igis-transport.ru"
    
//    private let serverURL = "https://socket.igis-transport.ru"
//    private let key = "mpqli8Jn2nUYxS1nf2wJbHXJCZWdtrWqPEV3wHJgjwzMgsRFmvpenZ7GghxwTZ14"
    
    private let key = "8pU5KKybo0Ivcz597yi23j9P37wzSzL6EP2jLoG7p5kUqX9S8S9vNiOMHlruwzYk"
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    private init() {
        if(GeneralViewModel.userTrace.isEmpty){
            debugPrint("Ошибка. Попытка подлючения с сокет-серверу до того, как был сформирован user-trace.")
            GeneralViewModel.checkTrace()
        }
        self.manager = SocketManager(socketURL: URL(string: serverURL)!, config: [.log(true), .compress, .extraHeaders(
            ["clbeicspz9cgfdpbrulh1vxlmmbzmvhy" : key,
             "language" : "ru",
             "city":"izh",
             "trace": GeneralViewModel.userTrace
            ])])
        self.socket = manager.defaultSocket
        
        manager.reconnectWait = 5
        manager.reconnectWaitMax = 5
        socket.manager?.reconnectWait = 5
        socket.manager?.reconnectWaitMax = 5
        
        setSubscribes()
        establishConnection()
    }
    
    private var currentCallback: ((Data) -> ())? = {_ in
        
    }
    
    private func subscribeCliSerSubscribeToEvent(){
        
        socket.on("serCliDataInPage") { some1, some2 in
            let queue = DispatchQueue.global(qos: .default)
            queue.async {
                if let data = some1.first as? Data, let currentCallback = self.currentCallback{
                    currentCallback(data)
                }else{
                    debugPrint("ошибка расшифровки ответа от сервера \(Date.now)")
                }
            }
        }
    }
    
    // Подписка на событие.
    func emitOn(event: String, items: SocketData, callback: @escaping (Data)->() ){
        self.socket.emit(event, items)
        self.currentCallback = callback
    }
    
    private func setSubscribes(){
        
//        socket.onAny { SocketAnyEvent in
//            debugPrint(SocketAnyEvent.description)
//        }
        
        socket.on("connect") { some1 , some2 in
            debugPrint("сокет подключен(событие сервера) \(Date.now)")
        }
        
        socket.on(clientEvent: .disconnect){ some1, some2 in
            debugPrint("сокет отключен(событие клиента) \(Date.now)")
        }
        
//        socket.on("fromServerTest") { array, emmiter in
//
//        }
        
        subscribeCliSerSubscribeToEvent()
        
    }
    
    func establishConnection(){
        socket.connect()
        debugPrint("сокет-сервер - попытка подключения")
    }
    
    func disconnect(){
        socket.disconnect()
    }
}
















