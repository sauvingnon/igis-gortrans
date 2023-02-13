//
//  DataController.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 11.02.2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DataBase")
    
    init(){
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
