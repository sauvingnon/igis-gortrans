//
//  Model.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import Foundation
import SwiftUI
import CoreData

struct Model: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var stops: FetchedResults<Stop>
    
    static let busArray = [2, 6, 7, 8, 9, 10, 11, 12, 15, 16, 18, 19, 21, 22, 23, 25, 26, 27, 28, 29, 31, 34, 36]
    static let trainArray = [1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12]
    static let trolleybusArray = [1, 2, 4, 6, 7, 9, 10, 14]
    
    var body: some View{
        VStack{
            List(stops){ stop in
                Text(stop.stopName ?? "Empty")
            }
            
            Button("Add"){
                let names = ["Maks", "Sasha", "Misha", "Nikita", "Maks", "Иван", "Гоша", "Евгений"]
                
                let chooseName = names.randomElement()!
                
                let stop = Stop(context: moc)
                stop.stopId = Int16.random(in: 1...10)
                stop.stopName = chooseName
                
                try? moc.save()
            }
            
        }
    }
    
}

enum TypeTransport{
    case bus
    case train
    case trolleybus
    case countryBus
}

struct Model_Priview: PreviewProvider {
    static var previews: some View {
        Model()
    }
}

