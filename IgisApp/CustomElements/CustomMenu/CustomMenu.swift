//
//  CustomMenu.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 18.02.2023.
//

import SwiftUI

struct CustomMenuTest: View {
    
    @State var isMenuOpen = false
    
    var someStops: Menu = Menu(menuItems: [MenuItem(startStopId: 10, endStopId: 10, offset: 50), MenuItem(startStopId: 10, endStopId: 10, offset: 100), MenuItem(startStopId: 10, endStopId: 10, offset: 150)], currentStop: MenuItem(startStopId: 10, endStopId: 10, offset: 150))
    
    var body: some View {
        customMenu(menu: someStops)
    }
    
}

extension CustomMenuTest{
    func customMenu(menu: Menu) -> some View {
        return ZStack {
            ForEach(menu.menuItems, id: \.self){ item in
                ZStack {
                    HStack{
                        Text("\(DataBase.getStopName(id: item.startStopId)) - \(DataBase.getStopName(id: item.endStopId))")
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
                    Text("\(DataBase.getStopName(id: menu.currentStop.startStopId)) - \(DataBase.getStopName(id: menu.currentStop.endStopId))")
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

class Menu: HashableClass, ObservableObject{
    var menuItems: [MenuItem]
    @Published var currentStop: MenuItem
    init(menuItems: [MenuItem], currentStop: MenuItem) {
        self.menuItems = menuItems
        self.currentStop = currentStop
    }
}

class MenuItem: HashableClass{
    var startStopId: Int
    var endStopId: Int
    var offset: Int
    init(startStopId: Int, endStopId: Int, offset: Int) {
        self.startStopId = startStopId
        self.endStopId = endStopId
        self.offset = offset
    }
}

struct CustomMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomMenuTest()
    }
}
