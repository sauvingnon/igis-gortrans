//
//  LabelIzhevsk.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.11.2023.
//

import SwiftUI

struct LabelIzhevsk: View {
    
    @State var withBackButton: Bool
    
    var handlerFunc: ()->()
    
    var body: some View {
        Button(action: {
            handlerFunc()
        }, label: {
            HStack{
                if withBackButton{
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
            }
            .frame(width: UIScreen.screenWidth-40, height: 60, alignment: .leading)
            .background(Color.orange)
            .cornerRadius(25)
            .padding(.top, 10)
        })
    }
}

#Preview {
    LabelIzhevsk(withBackButton: true){
    }
}
