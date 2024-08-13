//
//  QuestionsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct QuestionsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @State var scaleBack = 1.0
    
    var body: some View {
        VStack{
            
            CustomBackLabel(text: "Что такое IGIS:Транспорт?"){
                dismiss()
            }
            
            ScrollView{
                Text("С помощью приложения можно посмотреть с мобильного телефона, где находится и во сколько придет нужный автобус, троллейбус или трамвай. \nДанные о местоположении транспорта представляют транспортно-пассажирские компании города Ижевска. \n\nЗдесь Вы найдте ответы на часто задаваемые вопросы и информацию о работе приложения.")
                    .padding(.horizontal, 20)
                    .fontWeight(.light)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .padding(.vertical, 20)
                    .minimumScaleFactor(0.01)
                
                QuestionButton(text: DataBase.title3){
                    SettingsModel.setTitleDescription(title: DataBase.title3, description: DataBase.description3)
                    navigationStack.append(CurrentSettingsSelectionView.answers)
                }
                QuestionButton(text: DataBase.title2){
                    SettingsModel.setTitleDescription(title: DataBase.title2, description: DataBase.description2)
                    navigationStack.append(CurrentSettingsSelectionView.answers)
                }
                QuestionButton(text: DataBase.title1){
                    SettingsModel.setTitleDescription(title: DataBase.title1, description: DataBase.description1)
                    navigationStack.append(CurrentSettingsSelectionView.answers)
                }
                
                QuestionButton(text: DataBase.title4){
                    SettingsModel.setTitleDescription(title: DataBase.title4, description: DataBase.description4)
                    navigationStack.append(CurrentSettingsSelectionView.answers)
                }
            }
            
            Spacer()
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

struct QuestionsView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        QuestionsView(navigationStack: $stack)
    }
}
