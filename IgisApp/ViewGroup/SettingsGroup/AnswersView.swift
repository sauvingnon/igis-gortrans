//
//  AnswersView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct AnswersView: View {
    
    @ObservedObject var model = SettingsModel.shared
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentSettingsSelectionView]
    
    @State var scaleBack = 1.0
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
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            Text(model.answerTitle)
                .padding(.horizontal, 20)
                .lineLimit(2)
                .multilineTextAlignment(.trailing)
                .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                .fontWeight(.light)
                .font(.system(size: 25))
                .padding(.top, 20)
                .minimumScaleFactor(0.01)
            
            HStack{
                Text(model.answerDescription)
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
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

//struct AnswersView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnswersView()
//    }
//}
