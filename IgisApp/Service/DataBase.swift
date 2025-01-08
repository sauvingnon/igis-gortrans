//
//  SomeInformation.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 13.02.2023.
//

import Foundation
import MapKit
import SwiftUI

class DataBase{
    // Класс для хранения данных json
    private static var stops: [StopsStruct] = []
    
    // Получить название остановки в родительном падеже
    public static func getStopFinalName(stopId: Int) -> String {
        if let stop = stops.first(where: { stop in
            stop.stop_id == stopId
        }){
            if let finalName = stop.stop_final_name{
                return finalName
            }else if let nameShort = stop.stop_name_short{
                return nameShort
            }else if let name = stop.stop_name{
                return name
            }else{
                print("Остановка по указанному id \(stopId) не заполнено имя.")
                return "—"
            }
        }else{
            print("Остановка по указанному id \(stopId) не найдена.")
            return "—"
        }
    }
    
    public static func getStopAnnotations() -> [StopAnnotation]{
        var stopAnnotations: [StopAnnotation] = []
        
        stops.forEach { stop in
            if(stop.stop_type != 0){
                let types = getTypesTransportForStop(stopId: stop.stop_id)
                
                var color: Color = .orange
                var letter = "A"
                
                if(types.contains(.train)){
                    color = .red
                    letter = "T"
                }
                
                if(types.contains(.trolleybus)){
                    color = .blue
                    letter = "T"
                }
                
                if(types.contains(.bus) && types.contains(.trolleybus)){
                    color = .blue
                    letter = "AT"
                }
                
                stopAnnotations.append(StopAnnotation(stop_id: stop.stop_id, stop_name: stop.stop_name, stop_name_short: stop.stop_name_short, color: color, stop_direction: stop.stop_direction, stop_types: types, coordinate: CLLocationCoordinate2D(latitude: Double(stop.stop_lat ?? 0), longitude: Double(stop.stop_long ?? 0)), stop_demand: stop.stop_demand, letter: letter))
            }
        }
        
        return stopAnnotations
    }
    
    public static func getStopsOfRoute(routeId: Int) -> ([Int]) {
        let queue = DispatchQueue.global(qos: .default)
        return queue.sync {
            var result: [Int] = []
            subroutes.forEach { item in
                if(item.subroute_route == routeId){
                    result.append(contentsOf: item.subroute_stops)
                }
            }
            return result
        }
    }
    
    public static func getStopName(stopId: Int) -> String {
        if let stop = stops.first(where: { stop in
            stop.stop_id == stopId
        }), let name = stop.stop_name_short{
            return name
        }else{
            print("Остановка по указанному id не найдена или ее имя не заполнено!")
            return "—"
        }
    }
    
    public static func getStopDirection(stopId: Int) -> String{
        if let stop = stops.first(where: { stop in
            stop.stop_id == stopId
        }), let name = stop.stop_direction{
            return name
        }else{
            print("Остановка по указанному id не найдена или ее имя не заполнено!")
            return "—"
        }
    }
    
    public static func getAllStops() -> [StopsStruct]{
        return stops.filter { item in
            item.stop_type != 0
        }
    }
    
    private static var routes: [RouteStruct] = []
    
    public static func getAllRoutes() -> [RouteStruct]{
        return routes
    }
    
    public static func getTypeTransportFromId(routeId: Int) -> TypeTransport?{
        
        if let transport = routes.first(where: { item in
            item.route_id == routeId
        }){
            switch(transport.route_ts_type){
            case 1: return .bus
            case 2: return .trolleybus
            case 3: return .train
            default: return nil
            }
        }else{
            debugPrint("Маршрут не был найден. Невозможно определить тип транспорта.")
            return nil
        }
    }
    
    private static func fromEnumTsTypeToIntTsType(type: TypeTransport) -> Int{
        switch(type){
        case .bus:
            return 1
        case .train:
            return 3
        case .trolleybus:
            return 2
        case .countrybus:
            return 1
        }
    }
    
    static func getRouteNumber(routeId: Int) -> String{
        let queue = DispatchQueue.global(qos: .default)
        return queue.sync {
            if let route = routes.first(where: { item in
                item.route_id == routeId
            }){
                if(!route.route_number.isEmpty){
                    if(route.route_number.first!.isNumber){
                        return "№ \(route.route_number)"
                    }else{
                        return "\(route.route_number)"
                    }
                }
            }
            return "—"
        }
    }
    
    static func getRouteNumberForFetch(routeId: Int) -> String{
        let queue = DispatchQueue.global(qos: .default)
        return queue.sync {
            if let route = routes.first(where: { item in
                item.route_id == routeId
            }){
                if(!route.route_number.isEmpty){
                    return route.route_number
                }
            }
            return "—"
        }
    }
    
    static func getRouteId(type: TypeTransport, number: String) -> Int{
        let queue = DispatchQueue.global(qos: .default)
        return queue.sync {
            let intTypeTs = fromEnumTsTypeToIntTsType(type: type)
            if let transport = routes.first(where: { item in
                item.route_number == number && item.route_ts_type == intTypeTs
            }){
                return transport.route_id
            }
            return 0
        }
    }
    
    public static func getArrayNumbersRoutes(type: TypeTransport) -> [String]{
        let queue = DispatchQueue.global(qos: .default)
        return queue.sync {
            var rawValue = type.rawValue
            if(rawValue == 5){ rawValue = 1 }
            var result: [String] = []
            routes.forEach { item in
                if((item.route_ts_type == rawValue) && !result.contains(item.route_number)) {
                    if(type == .bus || type == .countrybus){
                        if(type == .bus && isCityRoute(routeId: item.route_id)){
                            result.append(item.route_number)
                        }else if(type == .countrybus && !isCityRoute(routeId: item.route_id)){
                            result.append(item.route_number)
                        }
                    }
                    else{
                        result.append(item.route_number)
                    }
                }
            }
            return result
        }
    }
    
    private static var subroutes: [SubrouteStruct] = []
    
    public static func getSubroutesOfRoute(routeId: Int) -> [SubrouteStruct]?{
        let queue = DispatchQueue.global(qos: .default)
        return queue.sync {
            var result: [SubrouteStruct] = []
            subroutes.forEach { item in
                if(item.subroute_route == routeId){
                    result.append(item)
                }
            }
            return result
        }
    }
    
    private static var city_routes: [CityRouteStruct] = []
    
    public static func isCityRoute(routeId: Int) -> Bool{
        let queue = DispatchQueue.global(qos: .default)
        return queue.sync {
            return (city_routes.first { item in
                item.city_route_route == routeId && item.city_route_geo == 1
            } != nil)
        }
    }
    
    private static var stopsOfTypeTransport: [Int: [TypeTransport]] = [:]
    
    public static func getTypesTransportForStop(stopId: Int) -> [TypeTransport]{
        if let types = stopsOfTypeTransport.first(where: { element in
            element.key == stopId
        })?.value{
            return types
        }else{
            debugPrint("Для указанной остановки не были найдены соответсвующие типы транспорта.")
            return []
        }
    }
    
    private static func fillStopsOfTypeTransport(){
        // Соберем информацию для всех остановок
        stops.forEach { stopItem in
            if(stopItem.stop_type != 0){
                let id = stopItem.stop_id
                var types: [TypeTransport] = []
                // Информацию будем брать из маршрутов, на которых есть эта остановка
                subroutes.forEach { subrouteItem in
                    // Если она есть там, нам надо узнать к какому маршруту она относится
                    if(subrouteItem.subroute_stops.contains(id)){
                        // Фильтр, нам нужны только те маршруты, на которых есть наша остановка
                        routes.filter(){ routeItem in
                            routeItem.route_id == subrouteItem.subroute_route
                        }.forEach { routeItem in
                            let stopType = getTypeTransportFromId(routeId: routeItem.route_id)
                            types.append(stopType ?? .bus)
                        }
                        
                    }
                }
                stopsOfTypeTransport.updateValue(types, forKey: id)
            }
        }
    }
    
    private static var stages: [StageStruct] = []
    
    public static func getStagesForRoute(route_id: Int) -> [[StageStruct]]{
        
        var stagesList = [[StageStruct]]()
        
        // Получить массив линий остановок
        let subroute = getSubroutesOfRoute(routeId: route_id)
        
        // Перебор массива линий остановок
        subroute?.forEach({ subroute_item in
            
            //Перебор остановок каждой линии
            for i in 0...subroute_item.subroute_stops.count-2 {
                
                let start_stop = subroute_item.subroute_stops[i]
                let end_stop = subroute_item.subroute_stops[i+1]
                
                // Получение всех перегонов для этой линии остановок
                let stages = getStagesForStops(stop_begin: start_stop, stop_end: end_stop)
                
                stagesList.append(stages)
                
            }
            
        })
        
        return stagesList
        
    }
    
    public static func getStagesForStops(stop_begin: Int, stop_end: Int) -> [StageStruct]{
        return stages.filter { item in
            item.stage_begin == stop_begin && item.stage_end == stop_end
        }
    }
    
    // MARK: - Загрузка данных из json в память
    static func LoadJSON(){
        //        let queue = DispatchQueue.global(qos: .default)
        
        // Инициализация избранных раньше чем загрузка маршрутов в память!
        //        queue.async {
        debugPrint("Загрузка json в память начата.")
        if let url = Bundle.main.url(forResource: "stop", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(StopsFileJSON.self, from: data)
                stops = jsonData.rows
            } catch {
                print("error:\(error)")
                print("Загрузка json структуры stop не удалась!")
            }
        }
        
        if let url = Bundle.main.url(forResource: "route", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(RouteFileJSON.self, from: data)
                routes = jsonData.rows
            } catch {
                print("error:\(error)")
                print("Загрузка json структуры route не удалась!")
            }
        }
        
        if let url = Bundle.main.url(forResource: "subroute", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(SubrouteFileJSON.self, from: data)
                subroutes = jsonData.rows
            } catch {
                print("error:\(error)")
                print("Загрузка json структуры subroute не удалась!")
            }
        }
        
        if let url = Bundle.main.url(forResource: "city_route", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(CityRouteFileJSON.self, from: data)
                city_routes = jsonData.rows
            } catch {
                print("error:\(error)")
                print("Загрузка json структуры city_route не удалась!")
            }
        }
        if let url = Bundle.main.url(forResource: "stage", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(StageFileJSON.self, from: data)
                stages = jsonData.rows
            } catch {
                print("error:\(error)")
                print("Загрузка json структуры stage не удалась!")
            }
        }
        debugPrint("Загрузка json в память завершена.")
        // Костыль! Перебор всех остановок и маршрутов циклом в цикле для получения соответствия: остановка - ее типы транспорта
        // Может существенно замедлить запуск приложения. Выполнение желательно на отдельном потоке.
        debugPrint("Старт загрузки типов транспорта - \(Date().description)")
        fillStopsOfTypeTransport()
        debugPrint("Окончание загрузки типов транспорта - \(Date().description)")
    }
    
    static let title1 = "Как настроить уведомления"
    static let description1 = " Для начала убедитесь, что показ уведомлений включен, для этого зайдите в настройки и найдите функцию \"Показывать уведомления\". \n\n После того, как вы убедились в том, что показ уведомлений включен, вам необходимо перейти на главное окно и нажать на кнопку \"Маршруты\". \n\n Выбрав нужный транспорт и его маршрут, перед вами окажется список остановок, через который проходит транспорт. Нажав на любую из остановок можно выставить уведомление на нужное время или поставить уведомление, которое сработает по прибытию транспорта на остановку."
    
    static let title2 = "Схемы движения транспорта по маршрутам"
    static let description2 = " Нажав на главном окне кнопку «Маршруты», можно выбрать интересующий вид транспорта: автобус, троллейбус, трамвай или пригородный автобус. \n Далее выберите номер маршрута, и вам будет показана линейная схема движения по направлению следования: прямое и обратное. \n На схеме отображены остановки и текущее положение транспорта. Также весь транспорт на маршруте можно увидеть и на карте города, нажав на ссылку в нижней части экрана «Показать на карте»."
    
    static let title3 = "Поиск транспорта по остановкам"
    static let description3 = " На главном окне кнопка «Остановки» позволяет выполнить поиск интересующей остановки по ее названию, а цветовой маркер рядом с названием обозначает тип транспорта: автобус, троллейбус, трамвай или пригородный автобус. Открыв нужную остановку, можно получить информацию по маршрутам и времени прибытия транспорта. Нажав номер маршрута, происходит переход на схему его движения. У некоторых остановок имеются фотографии. \n Маршруты и остановки можно добавлять в избранное для их быстрого поиска с главного окна приложения. \n Транспорт маркируется по состояниям: на остановке, в движении к остановке или в парк. Отдельно отмечен транспорт для людей с ограниченными возможностями (низкопольные автобусы)."
    
    static let title4 = "Почему не отображаются автобусы"
    static let description4 = "С 25.04.2024 АО ИПОПАТ временно приостановил передачу данных по автобусам в систему IGIS."
    
    static let feedBackEmail = "feedback@igis.ru"
    
}

struct StopsFileJSON: Decodable {
    // Тип для извлечения остановок из JSON
    let table: String
    let rows: [StopsStruct]
}

struct StopsStruct: Decodable, Hashable {
    // Тип используемый для остановок из JSON
    let stop_id: Int
    let stop_name: String?
    let stop_name_short: String?
    let stop_name_abbr: String?
    let stop_direction: String?
    let stop_type: Int?
    let stop_lat: Float?
    let stop_long: Float?
    let stop_final_name: String?
    let stop_demand: Int?
    let stop_photo_exist: Bool
}

struct RouteFileJSON: Decodable{
    // Тип для извлечения маршрутов из JSON
    let table: String
    let rows: [RouteStruct]
}

struct RouteStruct: Decodable{
    // Тип используемый для маршрутов из JSON
    let route_id: Int
    let route_translit: String
    let route_number: String
    let route_start: String?
    let route_inter: String?
    let route_finish: String?
    let route_ts_type: Int
    let route_conductor: Int
    let route_online: Int
    let route_iswork: Int
    let route_feature: String
    let route_begin: String?
    let route_end: String?
    let route_price_cash: Int
    let route_price_card: Int
    let route_price_bank_card: Int
    let route_color_key: String?
}

struct SubrouteFileJSON: Decodable{
    // Тип для извлечения веток маршрутов из JSON
    let table: String
    let rows: [SubrouteStruct]
}

struct SubrouteStruct: Decodable{
    // Тип используемый для веток маршрутов из JSON
    let subroute_id: Int
    let subroute_route: Int
    let subroute_direction: Int
    let subroute_stops: [Int]
    let subroute_number: Int?
    let subroute_diff: String?
    let subroute_main: Int?
}

struct CityRouteFileJSON: Decodable{
    // Тип для извлечения таблицы сопоставления маршрута и города из JSON
    let table: String
    let rows: [CityRouteStruct]
}

struct CityRouteStruct: Decodable{
    // Тип используемый для таблицы сопоставления маршрута и города из JSON
    let city_route_route: Int
    let city_route_city: Int
    let city_route_geo: Int
}

struct StageFileJSON: Decodable{
    // Тип для извлечения таблицы перегонов и города из JSON
    let table: String
    let rows: [StageStruct]
}

struct StageStruct: Decodable{
    // Тип используемый для таблицы перегонов и города из JSON
    let stage_begin: Int
    let stage_end: Int
    let stage_distance: Float
    let stage_coords: [[Float]]
}
