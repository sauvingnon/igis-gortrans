//
//  CustomMenu.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 18.02.2023.
//

import SwiftUI

struct CustomMenu: View {
    
    @State var isMenuOpen = false
    
    var someStops: Menu = Menu(menuItems: [MenuItem(stopId: 10, offset: 50), MenuItem(stopId: 41, offset: 100), MenuItem(stopId: 114, offset: 150)], currentStop: 59)
    
    var body: some View {
        customMenu(menu: someStops)
    }

}

extension CustomMenu{
    func customMenu(menu: Menu) -> some View{
        ZStack {
            ForEach(menu.menuItems, id: \.self){ item in
                ZStack {
                    HStack{
                        Text("ДО \(SomeInfo.stops[item.stopId]?.uppercased() ?? "Error")")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                    }
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Rectangle())
                    .cornerRadius(25)
                    .onTapGesture {
                        menu.currentStop = item.stopId
                        isMenuOpen.toggle()
                    }
                }
                .shadow(color: .black.opacity(isMenuOpen ? 0.1 : 0.0), radius: 10, x: 0, y: 5)
                .offset(y: isMenuOpen ? CGFloat(item.offset) : 0)
                .opacity(isMenuOpen ? 100 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5), value: isMenuOpen)
            }
            
            ZStack {
                HStack{
                    Text("ДО \(SomeInfo.stops[menu.currentStop]?.uppercased() ?? "Error")")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                    
                    Image(systemName: isMenuOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
                }
                .frame(minWidth: 250)
                .padding(10)
                .background(Color.blue)
                .clipShape(Rectangle())
                .cornerRadius(25)
            }
            .onTapGesture {
                isMenuOpen.toggle()
            }
        }
    }
}

class Menu: HashableClass, ObservableObject{
    var menuItems: [MenuItem]
    var currentStop: Int
    init(menuItems: [MenuItem], currentStop: Int) {
        self.menuItems = menuItems
        self.currentStop = currentStop
    }
}

class MenuItem: HashableClass{
    var stopId: Int
    var offset: Int
    init(stopId: Int, offset: Int) {
        self.stopId = stopId
        self.offset = offset
    }
}

struct CustomMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomMenu()
    }
}
