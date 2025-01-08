//
//  IgisAppApp.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct IgisAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Аналог AppDelegate из UIKit
    init(){
        UITabBar.appearance().isHidden = true
        DataBase.LoadJSON()
        GeneralViewModel.checkTrace()
        FireBaseService.shared.appWasLaunch()
    }

    var body: some Scene {
        WindowGroup {
            AppTabBarView()
        }
    }
}
