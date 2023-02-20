//
//  AboutAppView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct AboutAppView: View {
    
    @EnvironmentObject var currentViewSettings: currentSettingsViewClass
    
    var body: some View {
        VStack(){
            HStack(alignment: .center){
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 40)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                Text("О Программе")
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 25))
                Spacer()
                    
            }
            .padding(.top, 20)
            .onTapGesture {
                currentViewSettings.state = .settings
            }
            
            
            Spacer()
            
            Image("igis_icon")
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 15)
                .padding(.horizontal, 100)
                .offset(y: 50)
                .zIndex(1)
            VStack{
                Text("IGIS: Транспорт Ижевска")
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 20))
                    .padding(.top, 60)
                    .padding(.bottom, 10)
                    .kerning(1)
                GeometryReader{ geometry in
                    
                }
                .frame(height: 1)
                .background(Color.blue)
                .padding(.horizontal, 30)
                
                Text("Приложение предназначено для отображения текущего положения общественного транспорта города Ижевска в режиме онлайн.")
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                
                GeometryReader{ geometry in
                    
                }
                .frame(width: 40, height: 3)
                .background(Color.blue)
                .padding(.vertical, 20)
                
                VStack{
                    Text("ООО НПП Ижинформпроект")
                        .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                        .fontWeight(.light)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(20)
                    Text("г. Ижевск, ул. Бородина 21, офис 204")
                        .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                        .fontWeight(.light)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.bottom ,20)
                    Text("admin@igis.ru")
                        .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                        .fontWeight(.light)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.bottom ,20)
                        .underline()
                    Text("8-3412-68-12-97")
                        .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                        .fontWeight(.light)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.bottom ,20)
                        .underline()
                    
                }
                .frame(width: UIScreen.screenWidth-80)
                .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .leading, endPoint: .trailing)))
                .cornerRadius(30)
                
                Text("v1.5")
                    .kerning(1)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 0.7))
                    .padding(.bottom, 40)
                
            }
            .frame(width: UIScreen.screenWidth)
            .background(Color.white)
            .cornerRadius(30)
            .offset(y: 40)
            
            
            
            
            
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView()
    }
}
