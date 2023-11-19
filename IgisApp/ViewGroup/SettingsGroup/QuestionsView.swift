//
//  QuestionsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct QuestionsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentSettingsSelectionView]
    
    @State var scaleBack = 1.0
    @State var scaleButton1 = 1.0
    @State var scaleButton2 = 1.0
    @State var scaleButton3 = 1.0
    var body: some View {
        VStack{
            HStack(alignment: .top){
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .scaleEffect(scaleBack)
                    .onTapGesture {
                        scaleBack = 2.0
                        withAnimation(.spring(dampingFraction: 0.5)){
                            scaleBack = 1.0
                        }
                        dismiss()
                        
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
            
            questionButton(text: DataBase.title3)
                .onTapGesture {
                    scaleButton1 = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleButton1 = 1.0
                    }
                    SettingsModel.setTitleDescription(title: DataBase.title3, description: DataBase.description3)
                    navigationStack.append(.answers)
                }
                .scaleEffect(scaleButton1)
            questionButton(text: DataBase.title2)
                .onTapGesture {
                    scaleButton2 = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleButton2 = 1.0
                    }
                    SettingsModel.setTitleDescription(title: DataBase.title2, description: DataBase.description2)
                    navigationStack.append(.answers)
                }
                .scaleEffect(scaleButton2)
            questionButton(text: DataBase.title1)
                .onTapGesture {
                    scaleButton3 = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleButton3 = 1.0
                    }
                    SettingsModel.setTitleDescription(title: DataBase.title1, description: DataBase.description1)
                    navigationStack.append(.answers)
                }
                .scaleEffect(scaleButton3)
            
            Spacer()
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

//struct QuestionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionsView()
//    }
//}

extension QuestionsView{
    
    func questionButton(text: String) -> some View{
        HStack{
            Text(text)
                .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                .fontWeight(.light)
                .font(.system(size: 15))
                .padding(.leading, 10)
                .kerning(0.7)
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            Spacer()
                
        }
        .frame(width: UIScreen.screenWidth-40)
        .padding(.vertical, 15)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(red: 0.629, green: 0.803, blue: 1), radius: 10)
    }
}
