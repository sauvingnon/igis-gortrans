//
//  NearestStopGroupStackManager.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.03.2024.
//

import SwiftUI

struct NearestStopGroupStackManager: View {
    
    static let shared = NearestStopGroupStackManager()
    
    private init(){
        
    }
    
    private class NearestStopGroupStackManagerModel: ObservableObject {
        @Published var navigationStack = NavigationPath([CurrentTransportSelectionView]())
    }
    
    @ObservedObject private var model = NearestStopGroupStackManagerModel()
    
    var body: some View {
        CustomNavigationStack(path: $model.navigationStack){
            FindNearestStopsView(navigationStack: $model.navigationStack)
                .navigationDestination(for: CurrentTransportSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .showFavoriteItems:
                        FindNearestStopsView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showStopOnline:
                        ShowTransportStopView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showRouteOnline:
                        ShowTransportRouteView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .showTransportUnit:
                        ShowTransportUnitView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .notifications:
                        NotificationsView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    default:
                        FindNearestStopsView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    }
                }
                .navigationBarBackButtonHidden(true)
        }
    }
    
    // Очистка навигационного стека
    public func clearNavigationStack(){
        model.navigationStack.removeLast(model.navigationStack.count)
    }
}

struct NearestStopGroupStackManager_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesGroupStackManager.shared
    }
}
