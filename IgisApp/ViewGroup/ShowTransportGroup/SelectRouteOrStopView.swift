//
//  SelectRouteOrStopView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 09.02.2023.
//

import SwiftUI

struct SelectRouteOrStopView: View {
    
    @Binding var navigationStack: NavigationPath
    @ObservedObject var dateTime = DateTime()
    
    var body: some View {
        VStack{
            LabelIzhevsk(stack: $navigationStack){
            }
            HStack{
                Text(dateTime.date)
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    .kerning(2)
                    .offset(y: 17)
                Spacer()
                Text(dateTime.time)
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    .kerning(2)
                    .offset(y: 17)
            }
            .padding(.horizontal, 20)
            
            HStack{
                Text(dateTime.day)
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
                FavoritesGroupStackManager.shared.clearNavigationStack()
                navigationStack.append(CurrentTransportSelectionView.chooseTypeTransport)
                
            }, label: {
                Text("Маршруты")
                    .frame(width: UIScreen.screenWidth - 40, height: 120, alignment: .center)
                    .background(Color.orange)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            })
            
            Button(action: {
                FavoritesGroupStackManager.shared.clearNavigationStack()
                navigationStack.append(CurrentTransportSelectionView.selectStopView)
                
            }, label: {
                Text("Остановки")
                    .frame(width: UIScreen.screenWidth - 40, height: 120, alignment: .center)
                    .background(Color.blue)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .padding(20)
            })
            
            Spacer()
            
        }
    }
    
}

struct SelectRouteOrStopView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        SelectRouteOrStopView(navigationStack: $stack)
    }
}

class DateTime: ObservableObject{
    @Published var time: String = ""
    @Published var date: String = ""
    @Published var day: String = ""
    
    init() {
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.UpdateDateTime), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc private func UpdateDateTime(){
        getDay()
        getDate()
        getTime()
    }
    
    private func getTime(){
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        let dateString = formatter.string(from: Date())
        time = dateString
    }
    
    private func getDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        let dateString = formatter.string(from: Date())
        date = dateString
    }
    
    private func getDay(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ru_RU")
        let dateString = formatter.string(from: Date())
        day = dateString
    }
}
