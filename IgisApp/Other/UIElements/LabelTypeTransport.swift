//
//  ReadyElementsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2023.
//

import SwiftUI

struct LabelTypeTransport: View {
    
    let typeTransport: TypeTransport
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(getNameForTypeTransport(type: typeTransport))
                .foregroundColor(.blue)
                .font(.system(size: 25))
                .kerning(2)
                .offset(y: 17)
                .padding(.leading, 20)
                .minimumScaleFactor(0.01)
            GeometryReader { geometry in
                
            }
            .frame(height: 2)
            .background(Color.blue)
            .padding(.horizontal, 20)
        }
    }
    
    private func getNameForTypeTransport(type: TypeTransport) -> String {
        switch typeTransport {
        case .bus: "АВТОБУСЫ"
        case .countrybus: "ПРИГОРОД АВТОБУСЫ"
        case .train: "ТРАМВАИ"
        case .trolleybus: "ТРОЛЛЕЙБУСЫ"
        }
    }
}

