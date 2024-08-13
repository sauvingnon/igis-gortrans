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
    
    @State private var value: Float = 0.05
    
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
            
            
//            HStack{
//                Text("Показывать уведомления")
//                    .fixedSize()
//                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
//                    .fontWeight(.light)
//                    .font(.system(size: 18))
//                    .padding(.leading, 20)
//                    .kerning(0.7)
//                
//                Spacer()
//                
//                Toggle(isOn: $model.showNotifications){
//                    
//                }
//                .padding(.trailing, 20)
//            }
//            .frame(width: UIScreen.screenWidth-40)
//            .padding(.vertical, 15)
//            .background(Color.white)
//            .cornerRadius(15)
            
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
                    
                    var valueInMetters = Int(value*3000)
                    
                    if(valueInMetters < 500){
                        
                        valueInMetters = roundToInt(value: valueInMetters, devider: 50)
                        
                    }else if(valueInMetters < 1000){
                        
                        valueInMetters = roundToInt(value: valueInMetters, devider: 100)
                        
                    }else if(valueInMetters < 2000){
                        
                        valueInMetters = roundToInt(value: valueInMetters, devider: 250)
                        
                    }else if(valueInMetters < 3000){
                        
                        valueInMetters = roundToInt(value: valueInMetters, devider: 500)
                        
                    }
                    
                    value = Float(valueInMetters)/3000
                    
                    FindNearestStopsViewModel.shared.setValueDiff(value: value)
                })
                .padding(.horizontal, 20)
                
                Button(action: {
                    Vibration.selection.vibrate()
                    self.value = 0.05
                    FindNearestStopsViewModel.shared.setValueDiff(value: value)
                }, label: {
                    Text("Сброс")
                        .fontWeight(.light)
                        .font(.system(size: 18))
                        .kerning(0.7)
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .cornerRadius(15)
                })
                
            }
            .frame(width: UIScreen.screenWidth-40)
            .padding(.vertical, 15)
            .background(Color.white)
            .cornerRadius(15)
            
            Spacer()
            
            SettingsButton(imageName: "app.badge", text: "Изменить иконку"){
                navigationStack.append(CurrentSettingsSelectionView.changeIcon)
            }
            SettingsButton(imageName: "info.circle", text: "О приложении"){
                navigationStack.append(CurrentSettingsSelectionView.aboutApp)
            }
            SettingsButton(imageName: "questionmark.circle", text: "Помощь"){
                navigationStack.append(CurrentSettingsSelectionView.questions)
            }
            SettingsButton(imageName: "smiley", text: "Обратная связь"){
                navigationStack.append(CurrentSettingsSelectionView.feedBack)
            }
            
            Spacer()
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
    
    private func roundToInt(value: Int, devider: Int) -> Int {
        
        let result = value.quotientAndRemainder(dividingBy: devider)
        
        let a = Double(result.remainder)/Double(devider)
        
        if(a > 0.5){
            // округляем вверх
            return devider*(result.quotient+1)
        }else{
            // округляем вниз
            return devider*result.quotient
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        SettingsView(navigationStack: $stack)
    }
}
