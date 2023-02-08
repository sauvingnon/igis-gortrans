//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct ShowTransportView: View {
    
    @State var currentView: CurrentTransportViewType = .chooseRouteOrStation
    
    var body: some View {
        switch currentView {
        case .chooseRouteOrStation:
            SelectRouteOrStationView(currentView: $currentView)
        case .chooseTypeTransport:
            SelectTransportType(currentView: $currentView)
        case .chooseNumberTransport:
            SelectTransportNumber(currentView: $currentView, transportNumArray: Model.busArray)
        case .showTransportRoute:
            Text("Hello")
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        ShowTransportView()
    }
}

enum CurrentTransportViewType{
    case chooseRouteOrStation
    case chooseTypeTransport
    case chooseNumberTransport
    case showTransportRoute
}

