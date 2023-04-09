//
//  IgisAppApp.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

@main
struct IgisAppApp: App {
    
    // Аналог AppDelegate из UIKit
    init(){
        DataBase.LoadJSON()
    }

    var body: some Scene {
        WindowGroup {
            AppTabBarView()
        }
    }
}
