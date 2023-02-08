//
//  CustomTabBar.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

enum TabType: String{
    case home = "home_icon"
    case alerts = "alerts_icon"
    case map = "map_icon"
    case favourites = "favorites_icon"
    case settings = "settings_icon"
}

struct CustomTabBar: View {
    
    @Binding var selectedTab: TabType
    
    var body: some View {
        
        HStack(alignment: .center){
            CustomizeTabItem(tab: .home)
            CustomizeTabItem(tab: .alerts)
            CustomizeTabItem(tab: .map)
            CustomizeTabItem(tab: .favourites)
            CustomizeTabItem(tab: .settings)
        }
       .frame(height: 82)
    }
    
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(TabType.home))
    }
}

extension CustomTabBar{
    private func CustomizeTabItem(tab: TabType) -> some View{
        Button {
            selectedTab = tab
        } label: {
            VStack(alignment: .center, spacing: 4){
                Image(selectedTab == tab ? tab.rawValue + "_selected" : tab.rawValue)
            }
        }
        .tint(Color.gray)
        .padding(15)
    }
}
