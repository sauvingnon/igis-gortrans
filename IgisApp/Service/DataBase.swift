//
//  SomeInformation.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 13.02.2023.
//

import Foundation

class DataBase{
    // Класс для хранения данных json
    private static var stops: [StopsStruct] = []
    
    public static func getStopName(stopId: Int) -> String {
        let queue = DispatchQueue.global(qos: .default)
        return queue.sync {
            if let stop = stops.first(where: { stop in
                stop.stop_id == stopId
            }), let name = stop.stop_name_short{
                return name
            }else{
                print("Остановка по указанному id не найдена или ее имя не заполнено!")
                return "--"
            }
        }
    }
    
    public static func getStopDirection(stopId: Int) -> String{
        let queue = DispatchQueue.global(qos: .default)
        return queue.sync {
            if let stop = stops.first(where: { stop in
                stop.stop_id == stopId
            }), let name = stop.stop_direction{
                return name
            }else{
                print("Остановка по указанному id не найдена или ее имя не заполнено!")
                return "--"
            }
        }
    }
    
    public static func getAllStops() -> [StopsStruct]{
        return stops
    }
    
    private static var routes: [RouteStruct] = []
    
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
        }
        return nil
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
                return route.route_number
            }
            return "--"
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
    
    public static func getStopsOfRoute(routeId: Int) -> [SubrouteStruct]?{
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
    
    static func LoadJSON(){
        //        let queue = DispatchQueue.global(qos: .default)
        
        // Инициализация избранных раньше чем загрузка маршрутов в память!
        //        queue.async {
        
        // Функция для загрузки данных из json в статическую память
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
    }
    
    static let title1 = "Как настроить уведомления"
    static let description1 = " Для начала убедитесь, что показ уведомлений включен, для этого зайдите в настройки и найдите функцию \"Показывать уведомления\". \n\n После того, как вы убедились в том, что показ уведомлений включен, вам необходимо перейти на главное окно и нажать на кнопку \"Маршруты\". \n\n Выбрав нужный транспорт и его маршрут, перед вами окажется список остановок, через который проходит транспорт. Нажав на любую из остановок можно выставить уведомление на нужное время или поставить уведомление, которое сработает по прибытию транспорта на остановку."
    
    static let title2 = "Схемы движения транспорта по маршрутам"
    static let description2 = " Нажав на главном окне кнопку «Маршруты», можно выбрать интересующий вид транспорта: автобус, троллейбус, трамвай или пригородный автобус. \n Далее выберите номер маршрута, и вам будет показана линейная схема движения по направлению следования: прямое и обратное. \n На схеме отображены остановки и текущее положение транспорта. Также весь транспорт на маршруте можно увидеть и на карте города, нажав на ссылку в нижней части экрана «Показать на карте»."
    
    static let title3 = "Поиск транспорта по остановкам"
    static let description3 = " На главном окне кнопка «Остановки» позволяет выполнить поиск интересующей остановки по ее названию, а цветовой маркер рядом с названием обозначает тип транспорта: автобус, троллейбус, трамвай или пригородный автобус. Открыв нужную остановку, можно получить информацию по маршрутам и времени прибытия транспорта. Нажав номер маршрута, происходит переход на схему его движения. У некоторых остановок имеются фотографии. \n Маршруты и остановки можно добавлять в избранное для их быстрого поиска с главного окна приложения. \n Транспорт маркируется по состояниям: на остановке, в движении к остановке или в парк. Отдельно отмечен транспорт для людей с ограниченными возможностями (низкопольные автобусы)."
    
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
