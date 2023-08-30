//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct TransportGroupSelector: View {

    @StateObject var coordinator = coordinatorTransport()

    var body: some View {
        ZStack{
            switch coordinator.state {
            case .chooseRouteOrStation:
                coordinator.selectRouteOrStationView
            case .chooseTypeTransport:
                coordinator.selectTransportType
            case .chooseNumberTransport:
                coordinator.selectTransportNumber
            case .showRouteOnline:
                coordinator.showRouteOnline
            case .selectStopView:
                coordinator.selectStopView
            case .showStopOnline:
                coordinator.showStopOnline
            case .ShowTransportOnline:
                coordinator.showTransportOnline
            }
        }
        .environmentObject(coordinator)
    }

}

struct TransportGroupSelector_Preview: PreviewProvider {
    static var previews: some View {
        TransportGroupSelector()
    }
}

class coordinatorTransport: ObservableObject{
    @Published var state: CurrentTransportSelectionView = .chooseRouteOrStation
    let selectRouteOrStationView = SelectRouteOrStationView()
    let selectTransportType = SelectTransportType()
    let selectTransportNumber = SelectTransportNumber()
    let showRouteOnline = ShowRouteOnline()
    let selectStopView = SelectStopView()
    let showStopOnline = ShowStopOnline()
    let showTransportOnline = ShowTransportOnline()
    
    func show(view: CurrentTransportSelectionView){
        withAnimation(.easeIn(duration: 0.2)){
            state = view
        }
    }
}

enum CurrentTransportSelectionView{
    case chooseRouteOrStation
    case chooseTypeTransport
    case chooseNumberTransport
    case showRouteOnline
    case selectStopView
    case showStopOnline
    case ShowTransportOnline
}

