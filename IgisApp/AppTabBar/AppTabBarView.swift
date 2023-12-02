//
//  AppTabBarView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

struct AppTabBarView: View {
    
    @State private var selection: TabType = .home
    @ObservedObject private var model = AppTabBarModel.shared
    
    init(){
        GeneralViewModel.checkConnection()
    }
    
    var body: some View {
        VStack{
            ZStack{
                CustomTabBarContainerView(selection: $selection){
                    TransportGroupStackManager()
                        .tabBarTab(tab: .home, selection: $selection)
                    NotificationsView()
                        .tabBarTab(tab: .alerts, selection: $selection)
                    MapView()
                        .tabBarTab(tab: .map, selection: $selection)
                    FavoritesGroupStackManager()
                        .tabBarTab(tab: .favourites, selection: $selection)
                    SettingsGroupStackManager()
                        .tabBarTab(tab: .settings, selection: $selection)
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
