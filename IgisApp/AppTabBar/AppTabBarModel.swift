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
    
    @Published var selection: TabType = .home
    @Published var showStatus = false
    @Published var isConnected: ConnectionStatus = .notConnected
    @Published var colorStatus = Color.red
    @Published var textStatus = "Ожидание подключения"
    @Published var hideTabBar = false
    
    var alert: CustomAlert?
    @Published var alertIsPresented = false
    
    var timeAlert: ChooseTimeAlert?
    @Published var timeAlertIsPresented = false
    
    @Published var firstLaunch = false
    
}

enum ConnectionStatus{
    case isConnected
    case notConnected
    case waitSocket
}
