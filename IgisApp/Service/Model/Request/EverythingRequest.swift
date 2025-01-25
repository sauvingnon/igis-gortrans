//
//  EverythingRequest.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 12.01.2025.
//


struct EverythingRequest: Codable{
    // объект с городом для отправки запроса серверу
    let channel: String
    init(city: String) {
        self.channel = "/\(city)/everything"
    }
}