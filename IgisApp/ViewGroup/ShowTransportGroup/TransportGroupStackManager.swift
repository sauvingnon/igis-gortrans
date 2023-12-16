//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct TransportGroupStackManager: View {
    
    static let shared = TransportGroupStackManager()
    
    private init(){
        
    }

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
                    case .showTransportUnit:
                        ShowTransportUnitView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .findNearestStops:
                        FindNearestStopsView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .QRScanner:
                        ScannerView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
    
    func navigationStackWillAppear(){
        if let lastView = navigationStack.last{
            switch(lastView){
            case .chooseRouteOrStation:
                break
            case .chooseTypeTransport:
                break
            case .chooseNumberTransport:
                break
            case .showRouteOnline:
                ShowTransportRouteViewModel.shared.getRouteData()
                break
            case .selectStopView:
                break
            case .showStopOnline:
                ShowTransportStopViewModel.shared.getStationData()
                break
            case .showTransportUnit:
                ShowTransportUnitViewModel.shared.getTransportData()
                break
            case .findNearestStops:
                break
            case .QRScanner:
                break
            }
        }
    }
}

struct TransportGroupSelector_Preview: PreviewProvider {
    static var previews: some View {
        TransportGroupStackManager.shared
    }
}

enum CurrentTransportSelectionView{
    case chooseRouteOrStation
    case chooseTypeTransport
    case chooseNumberTransport
    case showRouteOnline
    case selectStopView
    case showStopOnline
    case showTransportUnit
    case findNearestStops
    case QRScanner
}

