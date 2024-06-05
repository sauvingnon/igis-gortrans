//
//  AppTabBarViewModel.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import Foundation
import SwiftUI

class AppTabBarViewModel{
    static let shared = AppTabBarViewModel()
    private init(){
        
    }
    @ObservedObject private var model = AppTabBarModel.shared
    
    func showAlert(title: String, message: String){
        model.alert = CustomAlert(isPresented: $model.alertIsPresented, title: title, message: message, dismissButton: CustomAlertButton(title: "OK"), primaryButton: nil, secondaryButton: nil)
        DispatchQueue.main.async {
            self.model.alertIsPresented = true
        }
    }
    
    func chooseTimeAlert(time: String, type: TypeTransport, route: String,  stop: Int){
        
        let nameTransport = GeneralViewModel.getName(type: type, number: route)
        
        let nameStop = DataBase.getStopName(stopId: stop)
        
        if let maybeTime = time.split(separator: " ").first, let minCount = Int(maybeTime){
            model.timeAlert = ChooseTimeAlert(isPresented: $model.timeAlertIsPresented, stop: nameStop, transport: nameTransport, minCount: minCount)
            model.timeAlertIsPresented = true
        }
        
    }
    
    // Ранее выбранный элемент таб-бара был нажат повторно.
    func onDoubleSelectTab(tab: TabType){
        switch(tab){
        case .home:
            TransportGroupStackManager.shared.clearNavigationStack()
            break
        case .nearest:
            NearestStopGroupStackManager.shared.clearNavigationStack()
            break
        case .map:
            MapGroupStackManager.shared.clearNavigationStack()
            break
        case .favourites:
            FavoritesGroupStackManager.shared.clearNavigationStack()
            break
        case .settings:
            SettingsGroupStackManager.shared.clearNavigationStack()
            break
        }
    }
    
    func hideTabBar(){
        withAnimation(.default, {
            model.hideTabBar = true
        })
    }
    
    func showTabBar(){
        withAnimation(.default, {
            model.hideTabBar = false
        })
    }
    
    func changeStatus(isConnected: ConnectionStatus){
        DispatchQueue.main.async {
            withAnimation(){
                switch(isConnected){
                case .isConnected:
                    self.model.colorStatus = Color.green
                    self.model.textStatus = "Подключение установлено"
                    self.model.isConnected = .isConnected
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.model.showStatus = false
                            }
                        }
                    }
                    break
                case .notConnected:
                    self.model.colorStatus = Color.red
                    self.model.textStatus = "Ожидание подключения"
                    self.model.isConnected = .notConnected
                    self.model.showStatus = true
                    break
                case .waitSocket:
                    self.model.colorStatus = Color.blue
                    self.model.textStatus = "Cоединение"
                    self.model.isConnected = .waitSocket
                    self.model.showStatus = true
                    break
                }
            }
        }
    }
}
