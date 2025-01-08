//
//  FirstLaunchStackManager.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 06.01.2025.
//


import SwiftUI

struct FirstLaunchStackManager: View {
    
    public static let shared = FirstLaunchStackManager()
    
    private init() {
        
    }
    
    private class FirstLaunchStackManagerModel: ObservableObject {
        @Published var navigationStack = NavigationPath([FirstLaunchSelectionView]())
    }
    
    @ObservedObject private var model = FirstLaunchStackManagerModel()

    var body: some View {
        NavigationStack(path: $model.navigationStack){
            WelcomeScreen(navigationStack: $model.navigationStack)
                .navigationDestination(for: FirstLaunchSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .welcome:
                        WelcomeScreen(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .needAccessToLocation:
                        GetLocationAccessView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .needAccessToNotifications:
                        GetNotificationsAccessView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .needAccessToCamera:
                        GetCameraAccessView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    }
                }
                .navigationBarBackButtonHidden(true)
        }
    }
    
    func dissmissViewEndCloseStack(){
        withAnimation{
            AppTabBarModel.shared.firstLaunch = false
        }
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3){
            UserDefaults.standard.set("1234567", forKey: "firstLaunch")
            model.navigationStack.removeLast(model.navigationStack.count)
        }
    }
    
}

struct FirstLaunchStackManager_Preview: PreviewProvider {
    static var previews: some View {
        FirstLaunchStackManager.shared
    }
}

enum FirstLaunchSelectionView {
    case welcome
    case needAccessToLocation
    case needAccessToNotifications
    case needAccessToCamera
}

