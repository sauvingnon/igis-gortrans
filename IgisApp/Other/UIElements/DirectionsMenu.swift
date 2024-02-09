//
//  CustomMenu.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 08.02.2024.
//

import SwiftUI

struct CustomMenu: View {
    
    @State var menu: Menu
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        ZStack {
            ForEach(menu.menuItems, id: \.self){ item in
                ZStack {
                    HStack{
                        Text("\(DataBase.getStopName(stopId: item.startStopId)) - \(DataBase.getStopName(stopId: item.endStopId))")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: UIScreen.screenWidth - 80)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Rectangle())
                    .cornerRadius(25)
                    .onTapGesture {
                        menu.currentStop = item
                        isMenuOpen.toggle()
                    }
                    .padding(.horizontal, 20)
                }
                .shadow(color: .black.opacity(isMenuOpen ? 0.1 : 0.0), radius: 10, x: 0, y: 5)
                .offset(y: isMenuOpen ? CGFloat(item.offset) : 0)
                .opacity(isMenuOpen ? 100 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5), value: isMenuOpen)
            }
            
            ZStack {
                HStack{
                    Text("\(DataBase.getStopName(stopId: menu.currentStop.startStopId)) - \(DataBase.getStopName(stopId: menu.currentStop.endStopId))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                    
                    Image(systemName: isMenuOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
                }
                .frame(minWidth: UIScreen.screenWidth-40)
                .padding(10)
                .background(Color.blue)
                .clipShape(Rectangle())
                .cornerRadius(25)
                .padding(.horizontal, 20)
            }
            .onTapGesture {
                isMenuOpen.toggle()
            }
            
        }
    }
}

//#Preview {
//    CustomMenu(menu: Menu(menuItems: [MenuItem(startStopId: 1137, endStopId: 1137, offset: 0)], currentStop: MenuItem(startStopId: 1137, endStopId: 1137, offset: 0)), isMenuOpen: )
//}
