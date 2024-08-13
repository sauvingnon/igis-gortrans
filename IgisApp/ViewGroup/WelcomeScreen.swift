//
//  WelcomeScreen.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 12.06.2024.
//

import SwiftUI

struct WelcomeScreen: View {
    
    var body: some View {
        VStack{
            
            Text("Дорогой пользователь,")
                .padding(.horizontal, 20)
                .lineLimit(2)
                .multilineTextAlignment(.trailing)
                .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                .fontWeight(.light)
                .font(.system(size: 25))
                .padding(.top, 20)
                .minimumScaleFactor(0.01)
            
            HStack{
                Text("""
    Мы рады представить вам наш новый продукт, который находится в стадии тестирования. Мы стремимся к тому, чтобы предоставить вам лучший опыт использования, однако в этой ранней стадии разработки возможны некоторые ошибки и недочеты.

    Ваше мнение имеет для нас большое значение, поэтому мы призываем вас принять участие в тестировании и поделиться своими отзывами. Ваши замечания помогут нам улучшить продукт и сделать его более удобным и функциональным. Инструменты для предоставления обратной связи вы можете найти на вкладке "Настройки".

    Мы благодарим вас за терпение и понимание, и уверяем вас, что мы работаем над тем, чтобы предоставить вам надежный и качественный продукт. Приятного использования.

    С уважением,
    Команда разработчиков
""")
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 14))
                    .padding(15)
                    .lineSpacing(2)
                    .minimumScaleFactor(0.01)
            }
                .frame(width: UIScreen.screenWidth-40)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(25)
                .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                withAnimation{
                    AppTabBarModel.shared.firstLaunch = false
                    UserDefaults.standard.set("1234567", forKey: "firstLaunch")
                }
            }, label: {
                Text("Продолжить")
                    .padding(10)
                    .bold()
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(10)
            })
            .padding(.top, 30)
            
            Spacer()
        }
        .frame(width: UIScreen.screenWidth)
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

#Preview {
    WelcomeScreen()
}
