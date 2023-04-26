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
    }
    
    var body: some View {
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
        .onAppear(){
            if(Model.setCurrentModeNetwork()){
                showAlert(title: "Активирован оффлайн режим", message: "Приложение переключит режим сразу после восстановления соединения")
                Model.tryConnect()
            }
        }
    }
    
    func showAlert(title: String, message: String){
        configuration.alert = CustomAlert(isPresented: $configuration.alertIsPresented, title: title, message: message, dismissButton: CustomAlertButton(title: "OK"), primaryButton: nil, secondaryButton: nil)
        DispatchQueue.main.async {
            configuration.alertIsPresented = true
        }
    }
}

private class AppConfiguration: ObservableObject{
    // класс для показа custom alert - можно обраться и показать из любого места в приложении
    @Published var alertIsPresented = false
    var alert: CustomAlert?
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}
