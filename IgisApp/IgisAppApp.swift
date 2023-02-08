//
//  IgisAppApp.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

@main
struct IgisAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AppTabBarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
