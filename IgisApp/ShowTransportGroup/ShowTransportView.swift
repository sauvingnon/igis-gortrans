//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct ShowTransportView: View {
    
//    @StateObject var data : CurrentData()
    
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
            case .selectStopView:
                currentView.selectStopView
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
    let selectStopView = SelectStopView()
}

enum CurrentTransportViewType{
    case chooseRouteOrStation
    case chooseTypeTransport
    case chooseNumberTransport
    case showTransportOnline
    case selectStopView
}

