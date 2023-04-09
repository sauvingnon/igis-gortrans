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
    
    public static func getStopName(id: Int) -> String {
        if let stop = stops.first(where: { stop in
            stop.stop_id == id
        }), let name = stop.stop_name_short{
            return name
        }else{
            print("Остановка по указанному id не найдена или ее имя не заполнено!")
            return "Ошибка"
        }
    }
    
    public static func getAllStops() -> [StopsStruct]{
        return stops
    }
    
    private static var routes: [RouteStruct] = []
    
    public static func getArrayNumbersRoutes(type: TypeTransport) -> [Int]{
        var result: [Int] = []
        routes.forEach { item in
            if(item.route_ts_type == type.rawValue) {
                result.append(Int(item.route_number) ?? 0)
            }
        }
        return result
    }
    
    private static var subroutes: [SubrouteStruct] = []
    
    static let stopsOfRouteOld: Dictionary<Int, arraySubroutes> = [
        14: arraySubroutes(arraySubroutes: [ .init(subroute: [361,362,370,1136,1134,1125,1126,1114,1108,1107,1105,1766,1790,1774,1776,1832,1835,1203,1370,1367,1289,1288,1303,1363,1360,1953,1955,10,9,14,3,1,467,469,470,2261,2233,2241]), .init(subroute: [474,2234,2262,471,468,466,2,4,13,6,7,1954,1952,1364,1358,1302,1292,1293,1369,2246,1368,1204,1834,1836,1778,1775,1781,1762,1767,1117,1119,1113,1127,1128,367,366,331,333,334,361]) ])
        // массив
    ]
    
    struct arraySubroutes{
        let arraySubroutes: [Subroute]
        struct Subroute{
            let subroute: [Int]
        }
    }
    
    static func LoadJSON(){
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
    }
    
    static let titele1 = "Как настроить уведомления"
    static let description1 = " Для начала убедитесь, что показ уведомлений включен, для этого зайдите в настройки и найдите функцию \"Показывать уведомления\". \n\n После того, как вы убедились в том, что показ уведомлений включен, вам необходимо перейти на главное окно и нажать на кнопку \"Маршруты\". \n\n Выбрав нужный транспорт и его маршрут, перед вами окажется список остановок, через который проходит транспорт. Нажав на любую из остановок можно выставить уведомление на нужное время или поставить уведомление, которое сработает по прибытию транспорта на остановку."
    
    static let titele2 = "Схемы движения транспорта по маршрутам"
    static let description2 = " Нажав на главном окне кнопку «Маршруты», можно выбрать интересующий вид транспорта: автобус, троллейбус, трамвай или пригородный автобус. \n Далее выберите номер маршрута, и вам будет показана линейная схема движения по направлению следования: прямое и обратное. \n На схеме отображены остановки и текущее положение транспорта. Также весь транспорт на маршруте можно увидеть и на карте города, нажав на ссылку в нижней части экрана «Показать на карте»."
    
    static let titele3 = "Поиск транспорта по остановкам"
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
