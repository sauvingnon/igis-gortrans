//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct SettingsGroupStackManager: View {
    
    public static let shared = SettingsGroupStackManager()
    
    private init() {
        
    }
    
    private class SettingsGroupStackManagerModel: ObservableObject {
        @Published var navigationStack = NavigationPath([CurrentSettingsSelectionView]())
    }
    
    @ObservedObject private var model = SettingsGroupStackManagerModel()

    var body: some View {
        
        NavigationStack(path: $model.navigationStack){
            SettingsView(navigationStack: $model.navigationStack)
                .navigationDestination(for: CurrentSettingsSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .settings:
                        SettingsView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .aboutApp:
                        AboutAppView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .changeIcon:
                        ChooseIconView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .questions:
                        QuestionsView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .answers:
                        AnswersView(navigationStack: $model.navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .feedBack:
                        FeedBackView(navigationStack: $model.navigationStack)
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

struct SettingsGroupSelector_Preview: PreviewProvider {
    static var previews: some View {
        SettingsGroupStackManager.shared
    }
}

enum CurrentSettingsSelectionView {
    case settings
    case aboutApp
    case feedBack
    case questions
    case answers
    case changeIcon
}

class SettingsModel: ObservableObject {
    
    static let shared = SettingsModel()
    private init(){
        
    }
    
    @Published var answerTitle = ""
    @Published var answerDescription = ""
    
    @Published var showNotifications = false
    @Published var offlineMode = false
    
    static func setTitleDescription(title: String, description: String) {
        SettingsModel.shared.answerTitle = title
        SettingsModel.shared.answerDescription = description
    }
}

