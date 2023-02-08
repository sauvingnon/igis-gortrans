//
//  TabBarTabsPreferenceKey.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import Foundation
import SwiftUI

class TabBarTabsPreferenceKey: PreferenceKey{
    
    static var defaultValue: [Tabs] = []
    
    static func reduce(value: inout [Tabs], nextValue: () -> [Tabs]) {
        value += nextValue()
    }
}

struct TabBarTabsModifier: ViewModifier{
    
    let tab: Tabs
    @Binding var selection: Tabs
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarTabsPreferenceKey.self, value: [tab])
    }
}

extension View{
    func tabBarTab(tab: Tabs, selection: Binding<Tabs>) -> some View{
        modifier(TabBarTabsModifier(tab: tab, selection: selection))
    }
}
