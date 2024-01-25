//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct SettingsGroupStackManager: View {
    
    @State private var navigationStack = NavigationPath([CurrentSettingsSelectionView]())

    var body: some View {
        
        CustomNavigationStack(path: $navigationStack){
            SettingsView(navigationStack: $navigationStack)
                .navigationDestination(for: CurrentSettingsSelectionView.self){ selectionView in
                    switch(selectionView){
                    case .settings:
                        SettingsView(navigationStack: $navigationStack)
                    case .aboutApp:
                        AboutAppView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .changeIcon:
                        ChooseIconView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .questions:
                        QuestionsView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .answers:
                        AnswersView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    case .feedBack:
                        FeedBackView(navigationStack: $navigationStack)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }

    }
}

struct SettingsGroupSelector_Preview: PreviewProvider {
    static var previews: some View {
        SettingsGroupStackManager()
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

