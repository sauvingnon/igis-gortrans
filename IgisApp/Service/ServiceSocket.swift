//
//  ServiceStation.swift
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
    
    private var currentUpdateScreen = ""
    
    private init() {
        if(GeneralViewModel.userTrace.isEmpty){
            let message = "Ошибка. Попытка подлючения с сокет-серверу до того, как был сформирован user-trace."
            debugPrint(message)
            Exception.throwError(message: message)
        }
        self.manager = SocketManager(socketURL: URL(string: serverURL)!, config: [.log(false), .compress, .extraHeaders(
            ["clbeicspz9cgfdpbrulh1vxlmmbzmvhy" : key,
             "language" : "ru",
             "city":"izh",
             "trace": GeneralViewModel.userTrace
            ])])
        self.socket = manager.defaultSocket
        
        manager.reconnectWait = 5;
        manager.reconnectWaitMax = 5;
        
        setSubscribes()
        establishConnection()
    }
    
    private func subscribeCliSerSubscribeToEvent(){
        // Надо бы распаралелить событие по названиям экранов
        socket.on("serCliDataInPage") { some1, some2 in
            let queue = DispatchQueue.global(qos: .default)
            queue.async {
            // Поочередно пробуем распарсить объект, чтобы понять к какому экрану он относится
                if let obj = try? MessagePackDecoder().decode(StationResponse.self, from: some1.first as! Data){
                    if(self.currentUpdateScreen == "ShowFavoriteStop"){
                        debugPrint("были получены данные о избранной остановке \(Date.now)")
                        ShowFavoriteStopViewModel.shared.updateStaionScreen(obj: obj)
                    }else{
                        debugPrint("были получены данные о остановке \(Date.now)")
                        ShowTransportStopViewModel.shared.updateStaionScreen(obj: obj)
                    }
                    return
                }
                if let obj = try? MessagePackDecoder().decode(EverythingResponse.self, from: some1.first as! Data){
                    debugPrint("были получены данные о всем транспорте на карте \(Date.now)")
                    MapViewModel.shared.updateMapScreen(obj: obj)
                    return
                }
                if let obj = try? MessagePackDecoder().decode(RouteResponse.self, from: some1.first as! Data){
                    if(self.currentUpdateScreen == "ShowFavoriteRoute"){
                        debugPrint("был получен прогноз избранного маршрута \(Date.now)")
                        ShowFavoriteRouteViewModel.shared.updateRouteScreen(obj: obj)
                    }else{
                        debugPrint("был получен прогноз маршрута \(Date.now)")
                        ShowTransportRouteViewModel.shared.updateRouteScreen(obj: obj)
                    }
                    return
                }
                if let obj = try? MessagePackDecoder().decode(TransportResponse.self, from: some1.first as! Data){
                    debugPrint("был получен прогноз транспорта \(Date.now)")
                    ShowTransportUnitViewModel.shared.updateTransportScreen(obj: obj)
                    return
                }
                if (try? MessagePackDecoder().decode(EmptryResponse.self, from: some1.first as! Data)) != nil{
                    debugPrint("был получен пустой ответ \(Date.now)")
                    GeneralViewModel.showAlertBadResponse()
                    return
                }
                debugPrint("ошибка расшифровки ответа от сервера \(Date.now)")
            }
        }
    }
    
    // MARK: - Подписка на событие.
    func emitOn(event: String, items: SocketData, updateScreen: String? = nil){
        GeneralViewModel.uncheckAlertAlreadyShow()
        if let screen = updateScreen{
            self.currentUpdateScreen = screen
        }
        self.socket.emit(event, items)
    }
    
    // MARK: - Отписка от события.
    func emitOff(){
        self.socket.emit("cliSerSubscribeOff")
        debugPrint("Завершили прием данных на событие: serCliDataInPage")
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

struct TransportRequest: Codable{
    // объект с идентификатором транспорта для отправки запроса серверу
    let channel: String
    init(transportId: String){
        self.channel = "/ts/\(transportId)"
    }
}

struct StationRequest: Codable{
    // объект с идентификатором остановки для отправки запроса серверу
    let channel: String
    init(stop_id: Int) {
        self.channel = "/station/\(stop_id)"
    }
}

struct EverythingRequest: Codable{
    // объект с городом для отправки запроса серверу
    let channel: String
    init(city: String) {
        self.channel = "/\(city)/everything"
    }
}

struct RouteRequest: Codable {
    let channel: String
    init(route_number: String, transport_type: TypeTransport) {
        let result = "/izh/\(RouteRequest.getName(transport_type: transport_type))/\(route_number)"
        self.channel = result
    }
    
    private static func getName(transport_type: TypeTransport) -> String {
        switch(transport_type){
        case .bus:
            return "citybus"
        case .train:
            return "tram"
        case .trolleybus:
            return "trolleybus"
        case .countrybus:
            return "suburbanbus"
        }
    }
}

struct TransportResponse: Codable {
    let code: String
    let data: DataObject
    struct DataObject: Codable {
        let azimuth: Int
//        let event_description: [Any]
        let gosnumber: String
        let latlng: [Float64]
        let main: Int
        let price: PriceObject
        struct PriceObject: Codable {
            let action: String?
            let action_price: Int?
            let bank_card: Int?
            let card: Int?
            let cash: Int?
        }
        let reys_status: String
        let route: String
        let time_reys: String
        let ts_stops: [TsStopsObject]
        struct TsStopsObject: Codable {
            let demand: Int
            let finish: Int
            let id: Int
            let latlng: [Float64]
            let name: String
//            let prediction: Array<String?>
        }
        let ts_type: String
    }
}

struct EmptryResponse: Codable {
    let code: String
}

struct RouteResponse: Codable {
    let code: String
    let data: DataObject
    struct DataObject: Codable {
        let notwork: Notwork
        struct Notwork: Codable {
            let code: String
            let description: String
            let network: [Int]
        }
        let scheme: [SchemeObject]
        struct SchemeObject: Codable {
            let sec: Int
            let stop: String
            let time: String?
            let ts: [TsObject]
            struct TsObject: Codable {
                let azimuth: Int
                let finish: FinishObject
                struct FinishObject: Codable {
                    let id: Int
                    let name: String
                }
                let gosnumber: String
                let id: String
                let latlng: [Float64]
                let lowfloor: String
                let reys_status: String
                let route: String
                let ts_type: String
            }
        }
//        let sender: String
//        let type: String
    }
}

struct EverythingResponse: Codable{
    let type: String
    let code: String
    let data: [DataObject]
    struct DataObject: Codable{
        let azimuth: Int
        let carrier: String
        let event: String?
        let gosnumber: String
        let id: String
        let inpark: Int
        let latlng: [Float64]
        // 0 - широта, 1 - долгота
        let lowfloor: String
        let main: Int
        let reys_status: String
        let route: String
        let sec: Int
        let stop: StopObject
        struct StopObject: Codable{
            let previous: Int?
            let current: Int?
            let next: Int?
            let finish: FinishObject
            struct FinishObject: Codable{
                let id: Int
                let name: String
            }
            
        }
        let ts_type: String
        let visible: Int
    }
}

struct StationResponse: Codable{
    let type: String
    let code: String
    let data: DataObject
    struct DataObject: Codable{
        let citybus: [TsObjectArray]
        let suburbanbus: [TsObjectArray]
        let trolleybus: [TsObjectArray]
        let tram: [TsObjectArray]
        struct TsObjectArray: Codable{
            let finish: [FinishArray]
            struct FinishArray: Codable{
                let all_in_line: Int
                let main: Int
                let sec: Int
                let stop: StopObject
                struct StopObject: Codable{
                    let id: Int
                    let name: String
                }
                let ts: TsObject?
                struct TsObject: Codable{
                    let id: String
                    let gosnumber: String
                    //                    let features: FeaturesObject?
                    //                    struct FeaturesObject: Codable{
                    //                        let fa: String
                    //                        let name: String
                    //                    }
                }
            }
            let route: RouteObject
            struct RouteObject: Codable{
                let id: Int
                let notwork: String?
                let time_last: Int
                let reys: ReysObject
                struct ReysObject: Codable{
                    let first: String?
                    let last: String?
                }
            }
        }
    }
}

