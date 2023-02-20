//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct TransportGroupSelector: View {

//    @StateObject var data : CurrentData()

    @StateObject var currentViewTransport = currentTransportViewClass()

    var body: some View {
        ZStack{
            switch currentViewTransport.state {
            case .chooseRouteOrStation:
                currentViewTransport.selectRouteOrStationView
            case .chooseTypeTransport:
                currentViewTransport.selectTransportType
            case .chooseNumberTransport:
                currentViewTransport.selectTransportNumber
            case .showTransportOnline:
                currentViewTransport.showTransportOnline
            case .selectStopView:
                currentViewTransport.selectStopView
            }
        }
        .environmentObject(currentViewTransport)
    }

}

struct TransportGroupSelector_Preview: PreviewProvider {
    static var previews: some View {
        TransportGroupSelector()
    }
}

class currentTransportViewClass: ObservableObject{
    @Published var state: CurrentTransportSelectionView = .chooseRouteOrStation
    let selectRouteOrStationView = SelectRouteOrStationView()
    let selectTransportType = SelectTransportType()
    let selectTransportNumber = SelectTransportNumber()
    let showTransportOnline = ShowTransportOnline()
    let selectStopView = SelectStopView()
}

enum CurrentTransportSelectionView{
    case chooseRouteOrStation
    case chooseTypeTransport
    case chooseNumberTransport
    case showTransportOnline
    case selectStopView
}

