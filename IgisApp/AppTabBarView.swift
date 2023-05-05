//
//  AppTabBarView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

struct AppTabBarView: View {
    
    @State private var selection: TabType = .home
    @ObservedObject private var configuration = AppConfiguration()
    
    init(){
        Model.appTabBarView = self
        Model.checkConnection()
    }
    
    var body: some View {
        VStack{
            ZStack{
                CustomTabBarContainerView(selection: $selection){
                    TransportGroupSelector()
                        .tabBarTab(tab: .home, selection: $selection)
                    NotificationsView()
                        .tabBarTab(tab: .alerts, selection: $selection)
                    Color.green
                        .onTapGesture {
                            showAlert(title: "Тест", message: "Тест")
                        }
                        .tabBarTab(tab: .map, selection: $selection)
                    FavoritesGroupSelector()
                        .tabBarTab(tab: .favourites, selection: $selection)
                    SettingsGroupSelector()
                        .tabBarTab(tab: .settings, selection: $selection)
                }
                if(configuration.alertIsPresented){
                    configuration.alert
                }
            }
            
            if(configuration.showStatus){
                HStack(alignment: .center){
                    Text(configuration.textStatus)
                        .padding(.trailing, 10)
                        .foregroundColor(.white)
                    if(configuration.isConnected){
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                    }else{
                        ProgressView()
                    }
                }
                .frame(width: UIScreen.screenWidth)
                .background(configuration.colorStatus)
            }
        }
        
    }
    
    func showAlert(title: String, message: String){
        configuration.alert = CustomAlert(isPresented: $configuration.alertIsPresented, title: title, message: message, dismissButton: CustomAlertButton(title: "OK"), primaryButton: nil, secondaryButton: nil)
        DispatchQueue.main.async {
            configuration.alertIsPresented = true
        }
    }
    
    func changeStatus(isConnected: Bool){
        DispatchQueue.main.async {
            if(isConnected){
                withAnimation(){
                    configuration.colorStatus = Color.green
                    configuration.textStatus = "Подключение установлено"
                    configuration.isConnected = true
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
                        DispatchQueue.main.async {
                            withAnimation {
                                configuration.showStatus = false
                            }
                        }
                    }
                }
            }
            else{
                withAnimation(){
                    configuration.colorStatus = Color.red
                    configuration.textStatus = "Ожидание подключения"
                    configuration.isConnected = false
                    configuration.showStatus = true
                }
            }
        }
    }
    
}

private class AppConfiguration: ObservableObject{
    // класс для показа custom alert - можно обраться и показать из любого места в приложении
    @Published var showStatus = false
    @Published var isConnected = false
    @Published var colorStatus = Color.red
    @Published var textStatus = "Ожидание подключения"
    @Published var alertIsPresented = false
    var alert: CustomAlert?
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}
