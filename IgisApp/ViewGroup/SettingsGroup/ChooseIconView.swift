//
//  ChooseIconView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 17.04.2023.
//

import SwiftUI

struct ChooseIconView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @State private var scale = 1.0
    @State private var iconNames = ["OtherIcon_1", "OtherIcon_2", "OtherIcon_3", "MainIcon"]
    
    var body: some View {
        VStack(){
            CustomBackLabel(text: "Изменить иконку"){
                dismiss()
            }
            
            ScrollView{
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20){
                    ForEach(iconNames, id: \.self){ name in
                        Button(action: {
                            changeIcon(to: name)
                        }){
                            Image(name)
                                .resizable()
                                .frame(maxWidth: 100, maxHeight: 100)
                        }
                    }
                }.padding(.horizontal, 20)
            }
            
            Spacer()
            
        }
        .background((LinearGradient(colors: [Color(red: 0.629, green: 0.803, blue: 1, opacity: 1), Color(red: 0.729, green: 0.856, blue: 1, opacity: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
    
    func changeIcon(to iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }
        
        if(iconName == "MainIcon"){
            UIApplication.shared.setAlternateIconName(nil, completionHandler: { (error) in
                if let error = error {
                    print("App icon failed to change due to \(error.localizedDescription)")
                } else {
                    print("App icon changed successfully")
                }
            })
        }else{
            UIApplication.shared.setAlternateIconName((iconName + "_Icon"), completionHandler: { (error) in
                if let error = error {
                    print("App icon failed to change due to \(error.localizedDescription)")
                } else {
                    print("App icon changed successfully")
                }
            })
        }
        
        
    }
    
}

struct ChooseIconView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        ChooseIconView(navigationStack: $stack)
    }
}

