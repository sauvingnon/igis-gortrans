//
//  SelectNumTSView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import SwiftUI

struct SelectNumTSView: View {
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let busArray = ["22", "23", "19", "36", "11", "25", "21", "1", "2", "6", "56", "26", "29", "37", "42", "57", "63", "77"]
    
    var body: some View {
        VStack(alignment: .leading){
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
            
            Text("АВТОБУСЫ")
                .foregroundColor(.blue)
                .font(.system(size: 25))
                .kerning(2)
                .offset(y: 17)
                .padding(.leading, 20)
                
                
            GeometryReader{ geomtry in
                
            }
            .frame(width: .infinity, height: 2)
            .background(Color.blue)
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(busArray, id: \.self){ bus in
                    Button(action: {
                        
                    }){
                        Text(bus)
                            .font(.system(size: 25))
                            .fontWeight(.black)
                            .frame(width: 65, height: 65)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
            }.padding(20)
            
            Spacer()
        }
        
    }
    
    private func getTSArray(){
        
    }
}

struct SelectNumTSView_Previews: PreviewProvider {
    static var previews: some View {
        SelectNumTSView()
    }
}
