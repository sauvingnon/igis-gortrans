//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct SettingsGroupSelector: View {
    
    @StateObject var currentView = currentSettingsViewClass()
    
    var body: some View {
        ZStack{
            switch currentView.state{
            case .aboutApp:
                currentView.aboutAppView
            case .settings:
                currentView.settingsView
            case .feedBack:
                currentView.feedBackView
            case .questions:
                currentView.questionView
            case .answers:
                currentView.answerView
            }
        }
        .environmentObject(currentView)
    }

}

struct SettingsGroupSelector_Preview: PreviewProvider {
    static var previews: some View {
        SettingsGroupSelector()
    }
}

class currentSettingsViewClass: ObservableObject{
    @Published var state: CurrentSettingsSelectionView = .settings
    let settingsView = SettingsView()
    let aboutAppView = AboutAppView()
    let feedBackView = FeedBackView()
    let questionView = QuestionsView()
    var answerView = AnswersView(title: SomeInfo.titele1, description: SomeInfo.description1)
}

enum CurrentSettingsSelectionView{
    case settings
    case aboutApp
    case feedBack
    case questions
    case answers
}

