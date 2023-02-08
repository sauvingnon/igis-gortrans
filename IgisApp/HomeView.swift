//
//  RootView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 23.11.2022.
//

import SwiftUI

struct HomeView: View {
    
    @State var selectedTab: Tabs = .home
    
    var body: some View {
        VStack(alignment: .center){
            
            GeometryReader(){ geo in
                Text("ИЖЕВСК")
                    .padding(.leading, 30)
                    .frame(width: geo.size.width, height: 60, alignment: .leading)
                    .background(Color.orange)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 20.0)
            .padding(.top, 10)
            .frame(height: 60.0)
            
            Rectangle()
                .padding(.top, 10.0)
                .foregroundColor(.blue)
                .frame(width: 340, height: 10)
            
            
            HStack(){
                Button {
                    print("Кнопка автобусы нажата")
                } label: {
                    VStack(){
                        Image(systemName: "bus") .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Автобусы")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                
                
                Button {
                    
                } label: {
                    VStack(){
                        Image(systemName: "bus.doubledecker") .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Троллейбусы")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                
                
                
                
            }
            .padding(.top, 10)
            
            HStack(){
                Button {
                    
                } label: {
                    VStack(){
                        Image(systemName: "tram") .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Трамваи")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                
                Button {
                    
                } label: {
                    VStack(){
                        Image(systemName: "bus.fill") .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50).foregroundColor(Color.white)
                        Text("Пригородные автобусы")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                
            }
            Spacer()
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

