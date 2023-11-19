//
//  CustomTabBarContainerView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {
    
    @Binding var selection: TabType
    let content: Content
    @State private var tabs: [TabType] = []
    
    init(selection: Binding<TabType>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                content
            }
            CustomTabBar(selectedTab: $selection)
        }
        .onPreferenceChange(TabBarTabsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(.home)){
            Color.red
        }
    }
}
