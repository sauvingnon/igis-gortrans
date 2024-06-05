//
//  LabelIzhevsk.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import SwiftUI

struct LabelIzhevsk: View {
    
    var withBackButton: Bool?
    
    @Binding var stack: NavigationPath
    
    var handlerFunc: ()->()
    
    var body: some View {
        ZStack{
            Button(action: {
                handlerFunc()
            }, label: {
                HStack{
                    if withBackButton ?? false{
                        Image(systemName: "chevron.left")
                            .font(.system(size: 25))
                            .padding(.leading, 20)
                            .foregroundColor(.white)
                        Text("ИЖЕВСК")
                            .cornerRadius(25)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                    }else{
                        Text("ИЖЕВСК")
                            .padding(.leading, 20)
                            .cornerRadius(25)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                    }
                    Spacer()
                }
                .frame(width: UIScreen.screenWidth-40, height: 60)
                .background(Color.orange)
                .cornerRadius(25)
                .padding(.top, 10)
            })
            .disabled(!(withBackButton ?? false))
            
            Button(action: {
                stack.append(CurrentTransportSelectionView.QRScanner)
            }, label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            })
            .cornerRadius(15)
            .padding(.top, 10)
            .offset(x: UIScreen.screenWidth/2-60, y: 0)
            
            Button(action: {
                stack.append(CurrentTransportSelectionView.notifications)
            }, label: {
                Image(systemName: "bell")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            })
            .cornerRadius(15)
            .padding(.top, 10)
            .offset(x: UIScreen.screenWidth/2-120, y: 0)
        }
    }
}

struct LabelIzhevsk_Previews: PreviewProvider {
    
    @State static var navigationStack = NavigationPath()
    
    static var previews: some View {
        LabelIzhevsk(stack: $navigationStack){
            
        }
    }
}
