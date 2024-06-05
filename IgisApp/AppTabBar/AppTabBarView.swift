//
//  AppTabBarView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

struct AppTabBarView: View {
    
    @ObservedObject private var model = AppTabBarModel.shared
    
    init(){
        GeneralViewModel.checkConnection()
    }
    
    @State private var selection: TabType = .home
    
    var body: some View {
        VStack{
            // Контент - часть.
            TabView(selection: $selection){
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
                CustomTabBar(selectedTab: $selection)
            }
            
            // Статус соединения
            if(model.showStatus){
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
        .overlay{
            if(model.alertIsPresented){
                model.alert
            }else if(model.timeAlertIsPresented){
                model.timeAlert
            }
        }
        
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}
