//
//  AppTabBarView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

struct AppTabBarView: View {
    
    @ObservedObject private var model = AppTabBarModel.shared
    
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) var dismiss
    
    init(){
        GeneralViewModel.checkConnection()
        checkFirstLaunch()
    }
    
//    @State private var selection: TabType = .home
    
    var body: some View {
        VStack{
            // Контент - часть.
            TabView(selection: $model.selection){
                TransportGroupStackManager.shared
                    .tag(TabType.home)
                NearestStopGroupStackManager.shared
                    .tag(TabType.nearest)
                MapGroupStackManager.shared
                    .tag(TabType.map)
                FavoritesGroupStackManager.shared
                    .tag(TabType.favourites)
                SettingsGroupStackManager.shared
                    .tag(TabType.settings)
            }
            .frame(width: UIScreen.screenWidth)

            // Таб-бар
            if(!model.hideTabBar){
                CustomTabBar(selectedTab: $model.selection)
            }
            
            // Статус соединения
            if(model.showStatus && !model.firstLaunch){
                HStack(alignment: .center){
                    Text(model.textStatus)
                        .padding(.trailing, 10)
                        .foregroundColor(.white)
                    if(model.isConnected == .isConnected){
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                    }else{
                        ProgressView()
                    }
                }
                .frame(width: UIScreen.screenWidth)
                .background(model.colorStatus)
            }
        }
        .alert(model.systemErrorMessage, isPresented: $model.systemShowError){
            Button("Настройки") {
                let settingsString = UIApplication.openSettingsURLString
                if let settingsURL = URL (string: settingsString) {
                    openURL(settingsURL)
                }
            }
            
            Button ("Отменить", role: .cancel) {
                dismiss()
            }
        }
        .overlay{
            if(model.alertIsPresented){
                model.alert
            }else if(model.timeAlertIsPresented){
                model.timeAlert
            }else if(model.firstLaunch){
                ZStack{
                    Color.white
                    FirstLaunchStackManager.shared
                }
                
            }
        }
        
    }
    
    func checkFirstLaunch(){
        // Алерт о тестировании приложения и добавление в стек навигации экранов запроса доступа к геолокации и уведомлениям
        if(UserDefaults.standard.object(forKey: "firstLaunch") == nil){
            model.firstLaunch.toggle()
            FireBaseService.shared.firstLaunch()
        }
    }
    
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}
