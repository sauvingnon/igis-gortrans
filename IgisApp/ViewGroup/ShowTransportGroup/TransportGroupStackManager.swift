//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct TransportGroupStackManager: View {
    
    static let shared = TransportGroupStackManager()
    
    @ObservedObject private var model = TransportGroupStackManagerModel()
    
    private init(){
    }
    
    private class TransportGroupStackManagerModel: ObservableObject {
        @Published var navigationStack = NavigationPath([CurrentTransportSelectionView]())
    }
    
    var body: some View {
        CustomNavigationStack(path: $model.navigationStack){
            SelectRouteOrStationView(navigationStack: $model.navigationStack)
                .navigationDestination(for: CurrentTransportSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .chooseRouteOrStation:
                        SelectRouteOrStationView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .chooseTypeTransport:
                        SelectTransportType(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .chooseNumberTransport:
                        ChooseTransportRouteView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showRouteOnline:
                        ShowTransportRouteView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .selectStopView:
                        SelectStopView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showStopOnline:
                        ShowTransportStopView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showTransportUnit:
                        ShowTransportUnitView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .findNearestStops:
                        FindNearestStopsView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .QRScanner:
                        ScannerView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    }
                }
                .navigationBarBackButtonHidden(true)
        }
    }
    
    // Очистка навигационного стека
    public func clearNavigationStack(){
        model.navigationStack.removeLast(model.navigationStack.count-1)
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

