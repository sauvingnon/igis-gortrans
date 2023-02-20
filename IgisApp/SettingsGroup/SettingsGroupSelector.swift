//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct SettingsGroupSelector: View {
    
    @StateObject var currentView = currentSettingsViewClass()
    
    var body: some View {
        ZStack{
            if(currentView.state == .settings){
                currentView.settingsView
            }else{
                currentView.aboutAppView
            }
        }
        .environmentObject(currentView)
    }

}

struct SettingsGroupSelector_Preview: PreviewProvider {
    static var previews: some View {
        SettingsGroupSelector()
    }
}

class currentSettingsViewClass: ObservableObject{
    @Published var state: CurrentSettingsSelectionView = .settings
    let settingsView = SettingsView()
    let aboutAppView = AboutAppView()
}

enum CurrentSettingsSelectionView{
    case settings
    case aboutApp
}

