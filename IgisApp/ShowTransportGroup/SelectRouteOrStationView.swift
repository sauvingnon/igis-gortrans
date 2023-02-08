//
//  SelectRouteOrStationView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 09.02.2023.
//

import SwiftUI

struct SelectRouteOrStationView: View {
    
    @Binding var currentView: CurrentTransportViewType
    
    var body: some View {
        VStack{
            labelIzhevsk()
            HStack{
                Text("9 февраля")
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    .kerning(2)
                    .offset(y: 17)
                Spacer()
                Text("00:31")
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    .kerning(2)
                    .offset(y: 17)
            }
            .padding(.horizontal, 20)
            
            HStack{
                Text("Четверг")
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
                    .kerning(2)
                    .offset(y: 17)
                    .padding(.bottom, 15)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            GeometryReader{ geometry in
                
            }
            .frame(height: 2)
            .background(Color.blue)
            .padding(.horizontal, 20)
            
            Button(action: {
                currentView = .chooseTypeTransport
            }, label: {
                Text("Маршруты")
                    .frame(width: UIScreen.screenWidth - 40, height: 120, alignment: .center)
                    .background(Color.orange)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .padding(20)
            })
            
            
            Button(action: {
                
            }, label: {
                Text("Остановки")
                    .frame(width: UIScreen.screenWidth - 40, height: 120, alignment: .center)
                    .background(Color.blue)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            })
            
            Spacer()
        }
    }
}

struct SelectRouteOrStationView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRouteOrStationView(currentView: .constant(.chooseTypeTransport))
    }
}
