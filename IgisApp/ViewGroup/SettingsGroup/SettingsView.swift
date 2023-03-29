//
//  SettingsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var navigator: currentSettingsViewClass
    
    @State var showNotifications = false
    @State var offlineMode = false
    
    
    @State var scaleAbout = 1.0
    @State var scaleHelp = 1.0
    @State var scaleFeedBack = 1.0
    var body: some View {
        VStack{
            HStack{
                Text("Настройки")
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 25))
                    .padding(.top, 20)
                Spacer()
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
            
            
            HStack{
                Text("Показывать уведомления")
                    .fixedSize()
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 18))
                    .padding(.leading, 20)
                    .kerning(0.7)
                    
                Spacer()
                
                Toggle(isOn: $showNotifications){
                    
                }
                .padding(.trailing, 20)
            }
            .frame(width: UIScreen.screenWidth-40)
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(15)
            
            HStack{
                Text("Оффлайн режим")
                    .fixedSize()
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .fontWeight(.light)
                    .font(.system(size: 18))
                    .padding(.leading, 20)
                    .kerning(0.7)
                    
                    
                Spacer()
                
                Toggle(isOn: $offlineMode){
                    
                }
                .padding(.trailing, 20)
            }
            .frame(width: UIScreen.screenWidth-40)
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(15)
            
            Spacer()
            
            settingsButton(imageName: "info.circle", text: "О приложении")
                .onTapGesture {
                    scaleAbout = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleAbout = 1.0
                    }
                    navigator.show(view: .aboutApp)
                }
                .scaleEffect(scaleAbout)
            settingsButton(imageName: "questionmark.circle", text: "Помощь")
                .onTapGesture {
                    scaleHelp = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleHelp = 1.0
                    }
                    navigator.show(view: .questions)
                }
                .scaleEffect(scaleHelp)
            settingsButton(imageName: "smiley", text: "Обратная связь")
                .onTapGesture {
                    scaleFeedBack = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleFeedBack = 1.0
                    }
                    navigator.show(view: .feedBack)
                }
                .scaleEffect(scaleFeedBack)
            
            Spacer()
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}
    
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView{
    
    func settingsButton(imageName: String, text: String) -> some View{
        HStack{
            Image(systemName: imageName)
                .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                .padding(.leading, 10)
            Text(text)
                .fixedSize()
                .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                .fontWeight(.light)
                .font(.system(size: 18))
                .padding(.leading, 10)
                .kerning(0.7)
            Spacer()
                
        }
        .frame(width: UIScreen.screenWidth-40)
        .padding(.vertical, 15)
        .background(Color.white)
        .cornerRadius(15)
    }
}
