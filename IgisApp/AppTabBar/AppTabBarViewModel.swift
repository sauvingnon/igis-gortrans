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
        self.model.alert = CustomAlert(isPresented: $model.alertIsPresented, title: title, message: message, dismissButton: CustomAlertButton(title: "OK"), primaryButton: nil, secondaryButton: nil)
        DispatchQueue.main.async {
            self.model.alertIsPresented = true
        }
    }
    
    func changeStatus(isConnected: ConnectionStatus){
        DispatchQueue.main.async {
            if(isConnected == .notConnected){
                withAnimation(){
                    self.model.colorStatus = Color.red
                    self.model.textStatus = "Ожидание подключения"
                    self.model.isConnected = .notConnected
                    self.model.showStatus = true
                }
            }
            else if(isConnected == .isConnected){
                withAnimation(){
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
                }
            }else{
                withAnimation(){
                    self.model.colorStatus = Color.blue
                    self.model.textStatus = "Cоединение"
                    self.model.isConnected = .waitSocket
                    self.model.showStatus = true
                }
            }
        }
    }
}
