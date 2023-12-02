//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct TransportGroupStackManager: View {

    @State private var navigationStack = [CurrentTransportSelectionView]()

    var body: some View {
        NavigationStack(path: $navigationStack){
            SelectRouteOrStationView(navigationStack: $navigationStack)
                .navigationDestination(for: CurrentTransportSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .chooseRouteOrStation:
                        SelectRouteOrStationView(navigationStack: $navigationStack)
                    case .chooseTypeTransport:
                        SelectTransportType(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .chooseNumberTransport:
                        ChooseTransportRouteView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showRouteOnline:
                        ShowTransportRouteView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .selectStopView:
                        SelectStopView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showStopOnline:
                        ShowTransportStopView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showTransportOnline:
                        ShowTransportUnitView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .findNearestStops:
                        FindNearestStopsView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }

}

struct TransportGroupSelector_Preview: PreviewProvider {
    static var previews: some View {
        TransportGroupStackManager()
    }
}

enum CurrentTransportSelectionView{
    case chooseRouteOrStation
    case chooseTypeTransport
    case chooseNumberTransport
    case showRouteOnline
    case selectStopView
    case showStopOnline
    case showTransportOnline
    case findNearestStops
}

