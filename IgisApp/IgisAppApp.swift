//
//  IgisAppApp.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

@main
struct IgisAppApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            AppTabBarView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
