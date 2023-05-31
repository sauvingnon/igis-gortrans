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

class ServiceStation{
    
    static let shared = ServiceStation()
    
    static var status: SocketIOStatus{
        get{
            return self.shared.socket.status
        }
    }
    
    private let serverURL = "https://socket.igis-transport.ru"
    
    private var configuration: ConfigurationStop?
    
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
        establishConnection()
    }
    
    func establishConnection(){
        // подписка на событие получения данных о прогнозе на конкретную остановку
        socket.on(clientEvent: .connect) { some1, some2 in
            debugPrint("socket connected - client message")
        }
        
        socket.on("connect") { some1 , some2 in
            debugPrint("socket connected - server message")
        }
        
        socket.on(clientEvent: .disconnect){ some1, some2 in
            
        }
        
        socket.on("serCliDataInPage"){ some1, some2 in
            let queue = DispatchQueue.global(qos: .default)
            queue.async {
//                if let obj = try? MessagePackDecoder().decode(StationResponse.self, from: some1.first as! Data){
//                    self.UpdateStaionScreen(obj: obj)
//                }else{
//                    debugPrint("error messagepack decode stationresponse from socket")
//                }
                let obj = try! MessagePackDecoder().decode(StationResponse.self, from: some1.first as! Data)
                self.UpdateStaionScreen(obj: obj)
            }
        }
        
        socket.connect()
    }
    
    func disconnect(){
        socket.disconnect()
    }
    
    func clearStationView(){
        DispatchQueue.main.async {
                self.configuration?.buses.removeAll()
                self.configuration?.countryBuses.removeAll()
                self.configuration?.trains.removeAll()
                self.configuration?.trolleybuses.removeAll()
                self.configuration?.showIndicator = true
        }
    }
    
    func UpdateStaionScreen(obj: StationResponse){
        if(configuration == nil) {
            return
        }
        if(!obj.data.citybus.isEmpty){
            var buses: [TransportWaiter] = []
            obj.data.citybus.forEach { item in
                buses.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: item.finish.first?.stop.name ?? "--", time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? 0)))
            }
            DispatchQueue.main.async {
                self.configuration!.buses = buses
            }
        }
        
        if(!obj.data.suburbanbus.isEmpty){
            var countryBuses: [TransportWaiter] = []
            obj.data.suburbanbus.forEach { item in
                countryBuses.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: item.finish.first?.stop.name ?? "--", time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? 0)))
            }
            DispatchQueue.main.async {
                self.configuration!.countryBuses = countryBuses
            }
        }
        
        if(!obj.data.tram.isEmpty){
            var trains: [TransportWaiter] = []
            obj.data.tram.forEach { item in
                trains.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: item.finish.first?.stop.name ?? "--", time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? 0)))
            }
            DispatchQueue.main.async {
                self.configuration!.trains = trains
            }
        }
        
        if(!obj.data.trolleybus.isEmpty){
            var trolleybuses: [TransportWaiter] = []
            obj.data.trolleybus.forEach { item in
                trolleybuses.append(TransportWaiter(transportNumber: "№ \(DataBase.getRouteNumber(routeId: item.route.id))", endStationName: item.finish.first?.stop.name ?? "--", time: Model.getTimeToArrivalInMin(sec: item.finish.first?.sec ?? 0)))
            }
            DispatchQueue.main.async {
                self.configuration!.trolleybuses = trolleybuses
            }
        }
        DispatchQueue.main.async {
            self.configuration?.showIndicator = false
        }
    }
    
    func getStationData(stop_id: Int, configuration: ConfigurationStop){
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            if(self.configuration == nil){
                self.configuration = configuration
            }
            self.clearStationView()
            while(ServiceStation.status != .connected){
                
            }
            self.socket.emit("cliSerSubscribeTo", try! MessagePackEncoder().encode(SomeObject(stop_id: stop_id)))
        }
    }
}

struct SomeObject: Codable{
    // объект с идентификатором нужной нам остановки для отправки серверу
    let channel: String
    init(stop_id: Int) {
        self.channel = "/station/\(stop_id)"
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
                    let last: String
                }
            }
        }
    }
}

