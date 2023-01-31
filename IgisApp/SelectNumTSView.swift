//
//  SelectNumTSView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import SwiftUI

struct SelectNumTSView: View {
    var transportType: TypeTransport
//    var transportArray = getTSArray()
    var body: some View {
        List() {
               ForEach(0..<8) { _ in
                   HStack {
                       ForEach(0..<3) { _ in
                           Image("orange_color")
                               .resizable()
                               .scaledToFit()
                   }
               }
           }
        }
    }
    
    private func getTSArray(){
        
    }
}

struct SelectNumTSView_Previews: PreviewProvider {
    static var previews: some View {
        SelectNumTSView(transportType: .bus)
    }
}
