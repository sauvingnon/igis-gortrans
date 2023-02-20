//
//  QuestionsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct QuestionsView: View {
    
    @EnvironmentObject var currentView: currentSettingsViewClass
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .onTapGesture {
                        currentView.state = .settings
                    }
                Spacer()
                Text("Что такое \n IGIS:Транспорт?")
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.regular)
                    .font(.system(size: 25))
                    .offset(y: 20)
                
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            Text("С помощью приложения можно посмотреть с мобильного телефона, где находится и во сколько придет нужный автобус, троллейбус или трамвай. \nДанные о местоположении транспорта представляют транспортно-пассажирские компании города Ижевска. \n\nЗдесь Вы найдте ответы на часто задаваемые вопросы и информацию о работе приложения.")
                .padding(.horizontal, 20)
                .fontWeight(.light)
                .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                .padding(.vertical, 20)
                .minimumScaleFactor(0.01)
            
            questionButton(text: SomeInfo.titele3)
                .onTapGesture {
                    currentView.answerView = AnswersView(title: SomeInfo.titele3, description: SomeInfo.description3)
                    currentView.state = .answers
                }
            questionButton(text: SomeInfo.titele2)
                .onTapGesture {
                    currentView.answerView = AnswersView(title: SomeInfo.titele2, description: SomeInfo.description2)
                    currentView.state = .answers
                }
            questionButton(text: SomeInfo.titele1)
                .onTapGesture {
                    currentView.answerView = AnswersView(title: SomeInfo.titele1, description: SomeInfo.description1)
                    currentView.state = .answers
                }
            
            Spacer()
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView()
    }
}

extension QuestionsView{
    
    func questionButton(text: String) -> some View{
        HStack{
            Text(text)
                .fixedSize()
                .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                .fontWeight(.light)
                .font(.system(size: 15))
                .padding(.leading, 10)
                .kerning(0.7)
                .minimumScaleFactor(0.01)
            Spacer()
                
        }
        .frame(width: UIScreen.screenWidth-40)
        .padding(.vertical, 15)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(red: 0.629, green: 0.803, blue: 1), radius: 10)
    }
}
