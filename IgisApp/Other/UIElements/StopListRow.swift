//
//  StopListRow.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.02.2024.
//

import SwiftUI

struct StopListRow: View{
    var station: Stop
    var handlerTransportImageTapp: (String?) -> ()
    var handlerLabelStopTapp: (Int?) -> ()
    var handlerLabelTimeTapp: (Stop) -> ()
    var body: some View{
        HStack{
            Button(action: {
                handlerLabelStopTapp(station.id)
            }, label: {
                Text(station.name)
                    .foregroundColor(.blue)
                    .fontWeight(.light)
                    .lineLimit(2)
            })
            
            switch(station.stationState){
            case .endStation:
                Image(station.withArrow ? "endStationWithArrow" : "endStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 30)
            case .someStation:
                Image(station.withArrow ? "someStationWithArrow" : "someStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
            case .startStation:
                Image("startStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
                    .padding(.top, 30)
            }
            
            VStack{
                if(!station.pictureTs.isEmpty){
                    HStack(alignment: .top){
                        Button(action: {
                            handlerTransportImageTapp(station.transportId)
                        }, label: {
                            Image(station.pictureTs)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(width: (station.pictureTs.isEmpty == station.time.isEmpty) ? 20 : 25, height: (station.pictureTs.isEmpty == station.time.isEmpty) ? 20 : 25)
                        })
                    }
                    .frame(width: 50, height: 50)
                    .offset(y: (station.pictureTs.isEmpty == station.time.isEmpty) ? 7 : 0)
                }
                if(!station.time.isEmpty){
                    Button(action: {
                        handlerLabelTimeTapp(station)
                    }, label: {
                        Text(station.time)
                            .frame(width: 50, height: 50)
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(.gray)
                            .offset(y: (station.pictureTs.isEmpty == station.time.isEmpty) ? -30 : 0)
                    })
                }
            }
        }
        .frame(height: 35)
    }
    
}

struct Stop: Identifiable, Hashable {
    let id: Int
    let name: String
    let stationState: StationState
    var pictureTs: String
    var time: String
    var transportId: String?
    let withArrow: Bool
    init(id: Int, name: String, stationState: StationState, pictureTs: String, time: String, transportId: String? = nil, withArrow: Bool) {
        self.id = id
        self.name = name
        self.stationState = stationState
        self.pictureTs = pictureTs
        self.time = time
        self.transportId = transportId
        self.withArrow = withArrow
    }
    // Ячейки можем пересоздать, тогда вью обновится
}

#Preview {
    StopListRow(station: Stop(id: 1156, name: "Леваневского", stationState: .someStation, pictureTs: "bus_icon_white", time: "5 мин", transportId: "", withArrow: false), handlerTransportImageTapp: {_ in
        
    }, handlerLabelStopTapp: {_ in 
        
    }, handlerLabelTimeTapp: {_ in
        
    })
}
