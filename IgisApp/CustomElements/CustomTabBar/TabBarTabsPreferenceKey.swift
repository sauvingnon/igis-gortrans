//
//  TabBarTabsPreferenceKey.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

//import Foundation
//import SwiftUI
//
//class TabBarTabsPreferenceKey: PreferenceKey{
//    
//    static var defaultValue: [TabType] = []
//    
//    static func reduce(value: inout [TabType], nextValue: () -> [TabType]) {
//        value += nextValue()
//    }
//}
//
//struct TabBarTabsModifier: ViewModifier{
//    
//    let tab: TabType
//    @Binding var selection: TabType
//    
//    func body(content: Content) -> some View {
//        content
//            .opacity(selection == tab ? 1.0 : 0.0)
//            .preference(key: TabBarTabsPreferenceKey.self, value: [tab])
//    }
//}
//
//extension View{
//    func tabBarItem(tab: TabType, selection: Binding<TabType>) -> some View{
//        modifier(TabBarTabsModifier(tab: tab, selection: selection))
//    }
//}
