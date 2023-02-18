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
                currentView.selectRouteOrStationView
            case .chooseTypeTransport:
                currentView.selectTransportType
            case .chooseNumberTransport:
                currentView.selectTransportNumber
            case .showTransportOnline:
                currentView.showTransportOnline
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
    let selectRouteOrStationView = SelectRouteOrStationView()
    let selectTransportType = SelectTransportType()
    let selectTransportNumber = SelectTransportNumber()
    let showTransportOnline = ShowTransportOnline()
}

enum CurrentTransportViewType{
    case chooseRouteOrStation
    case chooseTypeTransport
    case chooseNumberTransport
    case showTransportOnline
}

