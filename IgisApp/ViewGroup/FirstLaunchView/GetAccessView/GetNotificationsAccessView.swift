//
//  GetNotificationsView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 06.01.2025.
//

import SwiftUI

struct GetNotificationsAccessView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @State private var buttonWasTapped = false
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text("Для корректной работы приложения требуется доступ к центру уведомлений устройства. Это необходимо для отображения уведомлений о скором прибытии транспорта на остановку.")
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
            
            
            VStack{
                if(!buttonWasTapped){
                    Button(action: {
                        ChatModel.shared.requestNotificationAccess()
                        withAnimation{
                            buttonWasTapped = true
                        }
                    }, label: {
                        HStack{
                            Text("Предоставить доступ")
                            Image(systemName: "checkmark.square.fill")
                        }
                        .frame(width: UIScreen.screenWidth*0.8)
                        .padding(10)
                        .bold()
                        .foregroundStyle(.white)
                        .background(.green)
                        .cornerRadius(10)
                    })
                }
            
                Button(action: {
                    navigationStack.append(FirstLaunchSelectionView.needAccessToCamera)
                }, label: {
                    HStack{
                        if(buttonWasTapped){
                            Text("Продолжить")
                        }else{
                            Text("Продолжить без доступа")
                            Image(systemName: "xmark.square.fill")
                        }
                    }
                    .frame(width: UIScreen.screenWidth*0.8)
                    .padding(10)
                    .bold()
                    .foregroundStyle(buttonWasTapped ? .white : .black)
                    .background(buttonWasTapped ? .blue : .red)
                    .cornerRadius(10)
                })
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .frame(width: UIScreen.screenWidth)
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

struct GetNotificationsView_Preview: PreviewProvider {
    
    @State static var path = NavigationPath()
    
    static var previews: some View {
        GetNotificationsAccessView(navigationStack: $path)
    }
}
