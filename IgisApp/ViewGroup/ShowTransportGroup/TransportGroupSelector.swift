//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct TransportGroupSelector: View {

    @StateObject var navigation = NavigationTransport()

    var body: some View {
        // На данный момент zstack - в планах horizontal scroll
        ZStack{
            switch navigation.state {
            case .chooseRouteOrStation:
                navigation.selectRouteOrStationView
            case .chooseTypeTransport:
                navigation.selectTransportType
            case .chooseNumberTransport:
                navigation.selectTransportNumber
            case .showTransportOnline:
                navigation.showTransportOnline
            case .selectStopView:
                navigation.selectStopView
            }
        }
        .environmentObject(navigation)
    }

}

struct TransportGroupSelector_Preview: PreviewProvider {
    static var previews: some View {
        TransportGroupSelector()
    }
}

class NavigationTransport: ObservableObject{
    @Published var state: CurrentTransportSelectionView = .chooseRouteOrStation
    let selectRouteOrStationView = SelectRouteOrStationView()
    let selectTransportType = SelectTransportType()
    let selectTransportNumber = SelectTransportNumber()
    let showTransportOnline = ShowTransportOnline()
    let selectStopView = SelectStopView()
    
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
    case showTransportOnline
    case selectStopView
}

