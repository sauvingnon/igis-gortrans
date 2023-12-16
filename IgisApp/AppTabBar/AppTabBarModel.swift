//
//  AppTabBarModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import Foundation
import SwiftUI

class AppTabBarModel: ObservableObject{
    static let shared = AppTabBarModel()
    private init(){
        
    }
    
    // класс для показа custom alert - можно обраться и показать из любого места в приложении
    @Published var showStatus = false
    @Published var isConnected: ConnectionStatus = .notConnected
    @Published var colorStatus = Color.red
    @Published var textStatus = "Ожидание подключения"
    @Published var alertIsPresented = false
    var alert: CustomAlert?
    
}

enum ConnectionStatus{
    case isConnected
    case notConnected
    case waitSocket
}
