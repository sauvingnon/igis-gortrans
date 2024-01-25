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
    
    var body: some View {
        VStack{
            ZStack{
                CustomTabBarContainerView(selection: $model.selection){
                    TransportGroupStackManager.shared
                        .tabBarItem(tab: .home, selection: $model.selection)
                        .tag(TabType.home)
                    NotificationsView()
                        .tabBarItem(tab: .alerts, selection: $model.selection)
                        .tag(TabType.alerts)
                    MapView()
                        .tabBarItem(tab: .map, selection: $model.selection)
                        .tag(TabType.map)
                    FavoritesGroupStackManager.shared
                        .tabBarItem(tab: .favourites, selection: $model.selection)
                        .tag(TabType.favourites)
                    SettingsGroupStackManager()
                        .tabBarItem(tab: .settings, selection: $model.selection)
                        .tag(TabType.settings)
                }
                if(model.alertIsPresented){
                    model.alert
                }
            }
            
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
        
    }
    
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}
