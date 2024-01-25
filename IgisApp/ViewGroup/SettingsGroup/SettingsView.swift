//
//  SettingsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var navigationStack: NavigationPath
    
    @ObservedObject private var model = SettingsModel.shared
    @State private var value: Float = 0.1
    
    @State private var scaleAbout = 1.0
    @State private var scaleHelp = 1.0
    @State private var scaleFeedBack = 1.0
    @State private var scaleIcon = 1.0
    @State private var scaleSliderBlock = 1.0
    
//    init(navStack: [CurrentSettingsSelectionView]){
//        Model.settingsView = self
//        navigationStack = navStack
//    }
    
    var body: some View {
        VStack {
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
                
                Toggle(isOn: $model.showNotifications){
                    
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
                
                Toggle(isOn: $model.offlineMode){
                    
                }
                .padding(.trailing, 20)
                .disabled(true)
            }
            .frame(width: UIScreen.screenWidth-40)
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(15)
            
            VStack{
                HStack{
                    Text("Расстояние до ближайших остановок")
    //                    .fixedSize()
                        .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                        .fontWeight(.light)
                        .font(.system(size: 18))
                        .kerning(0.7)
                        .lineLimit(2)
                        .padding(.leading, 20)
                        .minimumScaleFactor(0.01)
                    Spacer()
                    Text("\(Int(value*3000)) м")
                        .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                        .fontWeight(.light)
                        .font(.system(size: 18))
                        .kerning(0.7)
                        .lineLimit(1)
                        .padding(.trailing, 20)
                }
                
                
                Slider(value: $value, onEditingChanged: {_ in 
                    FindNearestStopsViewModel.shared.setValueDiff(value: value)
                })
                .padding(.horizontal, 20)
            }
            .frame(width: UIScreen.screenWidth-40)
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(15)
            .scaleEffect(scaleSliderBlock)
            .onTapGesture(count: 2){
                FindNearestStopsViewModel.shared.setValueDiff(value: 0.1)
                Vibration.selection.vibrate()
                scaleSliderBlock = 0.5
                withAnimation(.spring(dampingFraction: 0.5)) {
                    scaleSliderBlock = 1.0
                    self.value = 0.1
                }
            }
            
            Spacer()
            
            settingsButton(imageName: "app.badge", text: "Изменить иконку")
                .onTapGesture {
                    scaleIcon = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleIcon = 1.0
                    }
                    navigationStack.append(CurrentSettingsSelectionView.changeIcon)
                    
                }
                .scaleEffect(scaleIcon)
            settingsButton(imageName: "info.circle", text: "О приложении")
                .onTapGesture {
                    scaleAbout = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleAbout = 1.0
                    }
                    navigationStack.append(CurrentSettingsSelectionView.aboutApp)
                }
                .scaleEffect(scaleAbout)
            settingsButton(imageName: "questionmark.circle", text: "Помощь")
                .onTapGesture {
                    scaleHelp = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleHelp = 1.0
                    }
                    navigationStack.append(CurrentSettingsSelectionView.questions)
                }
                .scaleEffect(scaleHelp)
            settingsButton(imageName: "smiley", text: "Обратная связь")
                .onTapGesture {
                    scaleFeedBack = 0.5
                    withAnimation(.spring(dampingFraction: 0.5)) {
                        scaleFeedBack = 1.0
                    }
                    navigationStack.append(CurrentSettingsSelectionView.feedBack)
                }
                .scaleEffect(scaleFeedBack)
            
            Spacer()
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
    
}
    
//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(navigationStack: .constant([]))
//    }
//}

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
