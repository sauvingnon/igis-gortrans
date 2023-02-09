//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct ShowTransportView: View {
    
    @StateObject var currentView = currentViewClass()
    
    var body: some View {
        ZStack{
            switch currentView.state {
            case .chooseRouteOrStation:
                SelectRouteOrStationView()
            case .chooseTypeTransport:
                SelectTransportType()
            case .chooseNumberTransport:
                SelectTransportNumber(transportNumArray: Model.busArray)
            case .showTransportRoute:
                Text("Hello")
            }
        }
        .environmentObject(currentView)
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        ShowTransportView()
    }
}

class currentViewClass: ObservableObject{
    @Published var state: CurrentTransportViewType = .chooseRouteOrStation
}

enum CurrentTransportViewType{
    case chooseRouteOrStation
    case chooseTypeTransport
    case chooseNumberTransport
    case showTransportRoute
}

