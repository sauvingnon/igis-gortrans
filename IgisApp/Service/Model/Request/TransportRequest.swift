//
//  TransportRequest.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 12.01.2025.
//


struct TransportRequest: Codable{
    // объект с идентификатором транспорта для отправки запроса серверу
    let channel: String
    init(transportId: String){
        self.channel = "/ts/\(transportId)"
    }
}