//
//  AppTabBarView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

struct AppTabBarView: View {
    @State private var selection: TabType = .home
    
    var body: some View {
        CustomTabBarContainerView(selection: $selection){
            ShowTransportView()
                .tabBarTab(tab: .home, selection: $selection)
            Color.red
                .tabBarTab(tab: .alerts, selection: $selection)
            Color.green
                .tabBarTab(tab: .map, selection: $selection)
            Color.blue
                .tabBarTab(tab: .favourites, selection: $selection)
            Color.black
                .tabBarTab(tab: .settings, selection: $selection)
            
        }
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}
