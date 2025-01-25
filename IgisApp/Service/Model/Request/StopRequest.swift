//
//  StopRequest.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 12.01.2025.
//


struct StopRequest: Codable{
    // объект с идентификатором остановки для отправки запроса серверу
    let channel: String
    init(stop_id: Int) {
        self.channel = "/station/\(stop_id)"
    }
}