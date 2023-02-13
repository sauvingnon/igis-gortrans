//
//  ShowTransportOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 09.02.2023.
//

import SwiftUI

struct ShowTransportOnline: View {
    
    @EnvironmentObject var currentView: currentViewClass
    
    private var columns: [GridItem] = [
        GridItem(.fixed(200)),
        GridItem(.fixed(200)),
        GridItem(.fixed(200))
    ]
    
    @State var transportName = "АВТОБУС №22"
    @State var transportTimeTable = "Ежедневно 6:00 - 21:30"
    @State var transportEndStation = "ДО ОСТ. САД ИЖСТАЛЬ"
    
    @State var array: [Station] = [Station(id: 1, name: "Транссельхозтехника", pictureStation: "start_station_img", pictureBus: "", time: "56 мин."),
                                   Station(id: 2, name: "Механизаторская улица", pictureStation: "station_img", pictureBus: "bus_img", time: ""),
                                   Station(id: 3, name: "Южные электросети", pictureStation: "station_img", pictureBus: "bus_img", time: ""),
                                   Station(id: 4, name: "Московская улица", pictureStation: "station_img", pictureBus: "", time: "2 мин."),
                                   Station(id: 5, name: "Железнодорожный вокзал", pictureStation: "station_img", pictureBus: "", time: "5 мин."),
                                   Station(id: 6, name: "Планерная улица", pictureStation: "station_img", pictureBus: "bus_img", time: ""),
    ]
    
    var body: some View {
        VStack{
            HStack{
                Text(transportName)
                    .padding(.leading, 30)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
                    .fontWeight(.black)
            }
            .onTapGesture {
                currentView.state = .chooseNumberTransport
            }
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.vertical, 10)
            
            HStack{
                Text(transportTimeTable)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                
            }, label: {
                HStack{
                    Text(transportEndStation)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                }
                .padding(10)
                .background(Color.blue)
                .clipShape(Rectangle())
                .cornerRadius(25)
            })
            
            ScrollView{
                Grid(alignment: .trailing){
                    ForEach(array) { item in
                        GridRow{
                            StationRow(station: item)
                        }
                    }
                }
            }
            
            
            
            Spacer()
        }
    }
}

struct ShowTransportOnline_Previews: PreviewProvider {
    static var previews: some View {
        ShowTransportOnline()
    }
}

struct StationRow: View{
    var station: Station
    
    var body: some View{
        HStack{
            Text(station.name)
                .foregroundColor(.blue)
                .fontWeight(.light)
            Image(station.pictureStation)
                .resizable()
                .frame(width: 50, height: 50)
            if(station.time.isEmpty){
                Image(station.pictureBus)
                    .resizable()
                    .frame(width: 50, height: 50)
            }else{
                Text(station.time)
                    .frame(width: 50, height: 50)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
            }
            
        }
        .frame(height: 35)
    }
    
}

struct Station: Codable, Hashable, Identifiable{
    var id: Int
    var name: String
    var pictureStation: String
    var pictureBus: String
    var time: String
}
