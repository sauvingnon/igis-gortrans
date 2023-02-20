//
//  AnswersView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct AnswersView: View {
    
    @EnvironmentObject var currentView: currentSettingsViewClass
    
    @State var title: String
    @State var description: String
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                    .onTapGesture {
                        currentView.state = .questions
                    }
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            Text(title)
                .multilineTextAlignment(.trailing)
                .foregroundColor(Color(red: 0.012, green: 0.306, blue: 0.635, opacity: 1))
                .fontWeight(.light)
                .font(.system(size: 25))
                .padding(.top, 20)
            
            HStack{
                Text(description)
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

struct AnswersView_Previews: PreviewProvider {
    static var previews: some View {
        AnswersView(title: SomeInfo.titele1, description: SomeInfo.description1)
    }
}
