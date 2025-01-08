//
//  FeedBackView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI
import MessageUI

struct FeedBackView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @FocusState private var textFieldFocuced: Bool{
        didSet{
            if(textFieldFocuced){
                AppTabBarViewModel.shared.showTabBar()
            }else{
                AppTabBarViewModel.shared.hideTabBar()
            }
        }
    }
    var email = DataBase.feedBackEmail
    @State var feedBack: String = ""
    
    @State var succes = false
    @State var scale = 1.0
    var body: some View {
        VStack{
            
            BackLabel(text: "Обратная связь"){
                dismiss()
            }
            
            Text("Здесь Вы можете оставить свой отзыв по работе приложения IGIS:Транспорт - благодарим :)")
//                .frame(width: UIScreen.screenWidth-40)
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
                .background(Color.white)
                .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                .fontWeight(.light)
                .font(.system(size: 14))
                .cornerRadius(25)
                .minimumScaleFactor(0.01)
            
            HStack{
               Text("Получатель: \(email)")
                    .foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0.7))
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    copyButtonTapped()
                }, label: {
                    Text(succes ? "Успешно✅" : "Копировать")
                        .font(.system(size: 18))
                        .padding(10)
                        .background(succes ? LinearGradient(colors: [Color(red: 0.012, green: 0.835, blue: 0.305, opacity: 1), Color(red: 0, green: 0.417, blue: 0.883, opacity: 0.92)], startPoint: .topLeading, endPoint: .bottomTrailing) : (LinearGradient(colors: [Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1), Color(red: 0, green: 0.417, blue: 0.883, opacity: 0.92)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.trailing, 10)
                })
            }
            .frame(width: UIScreen.screenWidth-40)
            .padding(.vertical, 10)
            .background((LinearGradient(colors: [Color(red: 0.323, green: 0.6, blue: 0.913, opacity: 1), Color(red: 0.604, green: 0.769, blue: 0.954, opacity: 1)], startPoint: .topLeading, endPoint: .bottomTrailing)))
            .cornerRadius(25)
            .padding(.top, 20)
            
            HStack{
                TextField(text: $feedBack, axis: .vertical){
                    Text("Напишите что-нибудь...")
                        .foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0.7))
                }
                .focused($textFieldFocuced)
                .frame(minWidth: 100, maxWidth: UIScreen.screenWidth, minHeight: 100, maxHeight: UIScreen.screenHeight/4, alignment: .topLeading)
                .padding(.horizontal, 20)
                .foregroundColor(.white)
                .lineLimit(10...20)
            }
            .frame(width: UIScreen.screenWidth-40)
            .padding(.vertical, 10)
            .background((LinearGradient(colors: [Color(red: 0.323, green: 0.6, blue: 0.913, opacity: 1), Color(red: 0.604, green: 0.769, blue: 0.954, opacity: 1)], startPoint: .topLeading, endPoint: .bottomTrailing)))
            .cornerRadius(25)
            
            HStack{
                Spacer()
                Button(action: {
                    sendFeedbackButtonTapped()
                }, label: {
                    Text("Отправить")
                        .font(.system(size: 18))
                        .padding(15)
                        .background((LinearGradient(colors: [Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1), Color(red: 0, green: 0.417, blue: 0.883, opacity: 0.92)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                })
                
            }
            .padding(.horizontal, 20)
            .onTapGesture {
                
            }
            Spacer()
        }
        .onTapGesture {
            textFieldFocuced = false
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
        .onDisappear{
            AppTabBarViewModel.shared.showTabBar()
        }
    }
    
    private func copyButtonTapped(){
        UIPasteboard.general.string = email
        withAnimation{
            succes.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            withAnimation{
                succes.toggle()
            }
        }
    }
    
    private func sendFeedbackButtonTapped(){
        
        if MFMailComposeViewController.canSendMail() {
            let recipientEmail = email
            let subject = "Отзыв о работе приложения IGIS: Транспорт онлайн"
            let body = feedBack
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let defaultUrl = URL(string: "mailto:\(recipientEmail)?subject=\(subjectEncoded)&body=\(bodyEncoded)")!
            UIApplication.shared.open(defaultUrl, options: [:], completionHandler: nil)
        } else {
            AppTabBarViewModel.shared.showAlert(title: "Невозможно отправить сообщение", message: "На вашем устройстве не доступны службы отправки почтовых сообщений. Вы можете скопировать почтовый адрес вручную и направить обращение.")
        }
            
    }
    
    
    
}

struct FeedBackView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        FeedBackView(navigationStack: $stack)
    }
}
