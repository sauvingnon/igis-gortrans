//
//  StopListRow.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.02.2024.
//

import SwiftUI

struct StopListRow: View{
    var stop: Stop
    var handlerTransportImageTapp: (String?) -> ()
    var handlerLabelStopTapp: (Int?) -> ()
    var handlerLabelTimeTapp: (Stop) -> ()
    var body: some View{
        HStack{
            Button(action: {
                handlerLabelStopTapp(stop.id)
            }, label: {
                Text(stop.name)
                    .foregroundColor(.blue)
                    .fontWeight(.light)
                    .lineLimit(2)
            })
            
            switch(stop.stopState){
            case .endStop:
                Image(stop.withArrow ? "endStationWithArrow" : "endStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 30)
            case .someStop:
                Image(stop.withArrow ? "someStationWithArrow" : "someStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
            case .startStop:
                Image("startStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
                    .padding(.top, 30)
            }
            
            VStack{
                if(!stop.pictureTs.isEmpty){
                    HStack(alignment: .top){
                        Button(action: {
                            handlerTransportImageTapp(stop.transportId)
                        }, label: {
                            Image(stop.pictureTs)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(width: (stop.pictureTs.isEmpty == stop.time.isEmpty) ? 20 : 25, height: (stop.pictureTs.isEmpty == stop.time.isEmpty) ? 20 : 25)
                        })
                    }
                    .frame(width: 50, height: 50)
                    .offset(y: (stop.pictureTs.isEmpty == stop.time.isEmpty) ? 7 : 0)
                }
                if(!stop.time.isEmpty){
                    Button(action: {
                        handlerLabelTimeTapp(stop)
                    }, label: {
                        Text(stop.time)
                            .frame(width: 50, height: 50)
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(.gray)
                            .offset(y: (stop.pictureTs.isEmpty == stop.time.isEmpty) ? -30 : 0)
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
    let stopState: StopState
    var pictureTs: String
    var time: String
    var transportId: String?
    let withArrow: Bool
    init(id: Int, name: String, stopState: StopState, pictureTs: String, time: String, transportId: String? = nil, withArrow: Bool) {
        self.id = id
        self.name = name
        self.stopState = stopState
        self.pictureTs = pictureTs
        self.time = time
        self.transportId = transportId
        self.withArrow = withArrow
    }
    // Ячейки можем пересоздать, тогда вью обновится
}

#Preview {
    StopListRow(stop: Stop(id: 1156, name: "Леваневского", stopState: .someStop, pictureTs: "bus_icon_white", time: "5 мин", transportId: "", withArrow: false), handlerTransportImageTapp: {_ in
        
    }, handlerLabelStopTapp: {_ in 
        
    }, handlerLabelTimeTapp: {_ in
        
    })
}
