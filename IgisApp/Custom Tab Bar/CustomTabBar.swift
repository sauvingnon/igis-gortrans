//
//  CustomTabBar.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

enum Tabs: Int{
    case home = 0
    case alerts = 1
    case map = 2
    case favourites = 3
    case settings = 4
}

struct CustomTabBar: View {
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        
        HStack(alignment: .center){
            
            Button {
                selectedTab = .home
            } label: {
                if(selectedTab == .home){
                    VStack(alignment: .center, spacing: 4){
                        Image("home_icon_selected")
                    }
                }else{
                    VStack(alignment: .center, spacing: 4){
                        Image("home_icon")
                    }
                }
                
                
            }
            .tint(Color.gray)
            .padding(15)
            
            Button {
                selectedTab = .alerts
            } label: {
                if(selectedTab == .alerts){
                    VStack(alignment: .center, spacing: 4){
                        Image("alerts_icon_selected")
                    }
                }else{
                    VStack(alignment: .center, spacing: 4){
                        Image("alerts_icon")
                    }
                }
                
                
            }
            .tint(Color.gray)
            .padding(15)
            
            Button {
                selectedTab = .map
            } label: {
                if(selectedTab == .map){
                    VStack(alignment: .center, spacing: 4){
                        Image("map_icon_selected")
                    }
                }else{
                    VStack(alignment: .center, spacing: 4){
                        Image("map_icon")
                    }
                }
                
            }
            .tint(Color.gray)
            .padding(15)
            
            Button {
                selectedTab = .favourites
            } label: {
                if(selectedTab == .favourites){
                    VStack(alignment: .center, spacing: 4){
                        Image("favorites_icon_selected")
                    }
                }else{
                    VStack(alignment: .center, spacing: 4){
                        Image("favorites_icon")
                    }
                }
                
                
            }
            .tint(Color.gray)
            .padding(15)
            
            Button {
                selectedTab = .settings
            } label: {
                if(selectedTab == .settings){
                    VStack(alignment: .center, spacing: 4){
                        Image("settings_icon_selected")
                    }
                }else{
                    VStack(alignment: .center, spacing: 4){
                        Image("settings_icon")
                    }
                }
                
                
            }
            .tint(Color.gray)
            .padding(15)

            
        }
        .frame(height: 82)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(Tabs.home))
    }
}

extension CustomTabBar{
    
    private func CustomizeTabView() -> some View{
        Button {
            selectedTab = .home
        } label: {
            if(selectedTab == .home){
                VStack(alignment: .center, spacing: 4){
                    Image("home_icon_selected")
                }
            }else{
                VStack(alignment: .center, spacing: 4){
                    Image("home_icon")
                }
            }
            
            
        }
        .tint(Color.gray)
        .padding(15)
    }
}
