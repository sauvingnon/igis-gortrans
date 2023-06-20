//
//  ServiceStation.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 30.05.2023.
//

import Foundation
import SocketIO
import SwiftUI
import MessagePacker
import MapKit

class ServiceSocket{
    
    static let shared = ServiceSocket()
    
    static var status: SocketIOStatus{
        get{
            return self.shared.socket.status
        }
    }
    
    private let serverURL = "https://socket.igis-transport.ru"
    
    private var configurationStop: ConfigurationStop?
    private var configurationMap: MapModel?
    private var configurationTransport: ConfigurationTransportOnline?
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    private init() {
        while(Model.userTrace.isEmpty){
            sleep(1)
            debugPrint("Error, userTrace is empty. Waiting userTrace")
        }
        self.manager = SocketManager(socketURL: URL(string: serverURL)!, config: [.log(false), .compress, .extraHeaders(
            ["clbeicspz9cgfdpbrulh1vxlmmbzmvhy" : "bjTE1AENWaVxFiKc5R1gA857NBo6XD2W",
             "language" : "ru",
             "city":"izh",
             "trace": Model.userTrace
            ])])
        self.socket = manager.defaultSocket
    }
    
    func establishConnection(){
        // подписка на событие получения данных о прогнозе на конкретную остановку
        if(socket.status == .connected || socket.status == .connecting){
            return
        }
//        socket.on(clientEvent: .connect) { some1, some2 in
//            debugPrint("socket connected - client message")
//        }
        
        socket.on("connect") { some1 , some2 in
            debugPrint("сокет подключен(событие сервере) \(Date.now)")
        }
        
        socket.on(clientEvent: .disconnect){ some1, some2 in
            debugPrint("сокет отключен(событие клиента \(Date.now))")
        }
        
        socket.on("serCliDataInPage"){ some1, some2 in
            let queue = DispatchQueue.global(qos: .default)
            queue.async {
                if let obj = try? MessagePackDecoder().decode(StationResponse.self, from: some1.first as! Data){
                    debugPrint("были получены данные о остановке \(Date.now)")
                    self.UpdateStaionScreen(obj: obj)
                    return
                }
                if let obj = try? MessagePackDecoder().decode(EverythingResponse.self, from: some1.first as! Data){
                    debugPrint("были получены данные о всем транспорте на карте \(Date.now)")
                    self.UpdateMapScreen(obj: obj)
                    return
                }
                if let obj = try? MessagePackDecoder().decode(RouteResponse.self, from: some1.first as! Data){
                    debugPrint("был получен прогноз маршрута \(Date.now)")
                    self.UpdateRouteScreen(obj: obj)
                    return
                }
                debugPrint("ошибка расшифровки ответа от сервера \(Date.now)")
                
//                let obj = try! MessagePackDecoder().decode(RouteResponse.self, from: some1.first as! Data)
//                self.UpdateRouteScreen(obj: obj)
            }
        }
        
        socket.connect()
    }
    
    func disconnect(){
        socket.disconnect()
    }
    
    func clearStationView(){
        DispatchQueue.main.async {
            self.configurationStop?.opacity = 0
            self.configurationStop?.buses.removeAll()
            self.configurationStop?.countryBuses.removeAll()
            self.configurationStop?.trains.removeAll()
            self.configurationStop?.trolleybuses.removeAll()
            self.configurationStop?.showIndicator = true
        }
    }
    
    func clearMapView(){
        DispatchQueue.main.async {
//            self.configurationMap?.locations.removeAll()
        }
    }
    
    func UpdateRouteScreen(obj: RouteResponse){
        if(configurationTransport == nil){
            return
        }
        var result: [Station] = []
        
        if(obj.data.notwork.code != "online" && obj.data.notwork.code != "noAnything"){
            debugPrint("статус маршрута не рабочий - \(obj.data.notwork.code)")
            return
        }
        
        let notSeenTransport = (obj.data.notwork.network.first ?? 0) - (obj.data.notwork.network.last ?? 0)
        if(notSeenTransport != 0){
            debugPrint("На маршруте не отображается \(notSeenTransport) единиц/ы транспорта")
        }
        
        configurationTransport?.data.forEach({ stationView in
            
            if let findStation = obj.data.scheme.first(where: { item in
                return item.stop == String(stationView.id)
            }){
                if(findStation.ts.count == 0){
                    if(findStation.sec > 3600){
                        result.append(Station(id: stationView.id, name: stationView.name, stationState: stationView.stationState, pictureTs: "", time: String((findStation.time)!)))
                    }else{
                        result.append(Station(id: stationView.id, name: stationView.name, stationState: stationView.stationState, pictureTs: "", time: Model.getTimeToArrivalInMin(sec: findStation.sec)))
                    }
                }else{
                    result.append(Station(id: stationView.id, name: stationView.name, stationState: stationView.stationState, pictureTs: getPictureTransport(type: (findStation.ts.first!.ts_type)), time: Model.getTimeToArrivalInMin(sec: findStation.sec)))
                }
            }
        })
        
        obj.data.scheme.forEach { item in
            if(item.stop.contains("-")){
                let stop_id = String(item.stop.split(separator: "-").last ?? "0")
                if let stationIndex = result.firstIndex(where: { station in
                    String(station.id) == stop_id
                }){
                    debugPrint("был отображен транспорт подьезд")
                    result[stationIndex].isNext = true
                    result[stationIndex].pictureTs = getPictureTransport(type: (item.ts.first!.ts_type))
                }
            }
        }
        
        DispatchQueue.main.async {
            self.configurationTransport?.data = result
        }
    }
    
    func UpdateStaionScreen(obj: StationResponse){
        if(configurationStop == nil) {
            return
        }
        if(!obj.data.citybus.isEmpty){
            var buses: [TransportWaiter] = []
            obj.data.citybus.forEach { item in
                buses.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName:  DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.configurationStop!.buses = buses
            }
        }
        
        if(!obj.data.suburbanbus.isEmpty){
            var countryBuses: [TransportWaiter] = []
            obj.data.suburbanbus.forEach { item in
                countryBuses.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.configurationStop!.countryBuses = countryBuses
            }
        }
        
        if(!obj.data.tram.isEmpty){
            var trains: [TransportWaiter] = []
            obj.data.tram.forEach { item in
                trains.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: DataBase.getStopName(stopId: item.finish.first?.stop.id ?? 0), time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? -1)))
            }
            DispatchQueue.main.async {
                self.configurationStop!.trains = trains
            }
        }
        
        if(!obj.data.trolleybus.isEmpty){
            var trolleybuses: [TransportWaiter] = []
            obj.data.trolleybus.forEach { item in
                trolleybuses.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: item.finish.first?.stop.name ?? "--", time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? 0)))
            }
            DispatchQueue.main.async {
                self.configurationStop!.trolleybuses = trolleybuses
            }
        }
        DispatchQueue.main.async {
            self.configurationStop?.showIndicator = false
            self.configurationStop?.showData()
        }
    }
    
    func getStationData(configuration: ConfigurationStop){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            if(self.configurationStop == nil){
                self.configurationStop = configuration
            }
            self.clearStationView()
            while(ServiceSocket.status != .connected){
                
            }
            self.socket.emit("cliSerSubscribeTo", try! MessagePackEncoder().encode(StationRequest(stop_id: configuration.stopId)))
        }
    }
    
    func getRouteData(configuration: ConfigurationTransportOnline){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            if(self.configurationTransport == nil){
                self.configurationTransport = configuration
            }
            while(ServiceSocket.status != .connected){
                
            }
            self.socket.emit("cliSerSubscribeTo", try! MessagePackEncoder().encode(RouteRequest(route_number: configuration.number, transport_type: configuration.type)))
        }
    }
    
    func UpdateMapScreen(obj: EverythingResponse){
        if(configurationMap == nil) {
            return
        }
        var bufferLocations: [MapModel.Location] = []
        obj.data.forEach { item in
            if(item.visible == 1 && item.reys_status == "ok"){
                bufferLocations.append(MapModel.Location(name: item.gosnumber, icon: self.getPictureTransport(type: item.ts_type), coordinate: CLLocationCoordinate2D(latitude: item.latlng.first!, longitude: item.latlng.last!)))
            }
        }
        DispatchQueue.main.async {
            self.configurationMap?.locations = bufferLocations
        }
        debugPrint("map was updated")
    }
    
    func getPictureTransport(type: String) -> String {
        switch type {
        case "citybus":
            return "bus"
        case "tram":
            return "tram"
        case "trolleybus":
            return "bus.doubledecker"
        case "suburbanbus":
            return "bus.fill"
        default:
            return ""
        }
    }
    
    func getEverythingData(city: String, configuration: MapModel){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            if(self.configurationMap == nil){
                self.configurationMap = configuration
            }
            self.clearMapView()
            while(ServiceSocket.status != .connected){
                
            }
            self.socket.emit("cliSerSubscribeTo", try! MessagePackEncoder().encode(EverythingRequest(city: "izh")))
        }
    }
}

struct StationRequest: Codable{
    // объект с идентификатором нужной нам остановки для отправки серверу
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

struct RouteRequest: Codable{
    let channel: String
    init(route_number: String, transport_type: TypeTransport) {
        let result = "/izh/\(RouteRequest.getName(transport_type: transport_type))/\(route_number)"
        self.channel = result
    }
    
    private static func getName(transport_type: TypeTransport) -> String{
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

struct RouteResponse: Codable{
    let code: String
    let data: DataObject
    struct DataObject: Codable{
        let notwork: Notwork
        struct Notwork: Codable{
            let code: String
            let description: String
            let network: [Int]
        }
        let scheme: [SchemeObject]
        struct SchemeObject: Codable{
            let sec: Int
            let stop: String
            let time: String?
            let ts: [TsObject]
            struct TsObject: Codable{
                let azimuth: Int
                let finish: FinishObject
                struct FinishObject: Codable{
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

