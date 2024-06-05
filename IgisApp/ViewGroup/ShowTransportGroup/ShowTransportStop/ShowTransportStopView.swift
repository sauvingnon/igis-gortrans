//
//  ShowStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 27.04.2023.
//

import SwiftUI

struct ShowTransportStopView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @ObservedObject var model = ShowStopOnlineModel()
    private var viewModel: ShowTransportStopViewModel!
    
    init(navigationStack: Binding<NavigationPath>, stopId: Int){
        self._navigationStack = navigationStack
        self.viewModel = ShowTransportStopViewModel(model: model)
        self.viewModel.configureView(stop_id: stopId)
    }
    
    @State private var sizeStar = 1.0
    
    var body: some View {
        VStack{
            LabelOfStopOrRoute(name: model.name, isFavorite: $model.isFavorite, backTapp: {
                dismiss()
            }, starTapp: {
                viewModel.favoriteStopTapped()
            })
            
            HStack{
                Text(model.direction)
                    .foregroundColor(.gray)
                    .kerning(1)
                    .padding(.horizontal, 10)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if(model.showIndicator){
                ProgressView()
            }
            
            ScrollView(.vertical){
                if(!model.buses.isEmpty){
                    LabelTypeTransport(typeTransport: .bus)
                    Grid(alignment: .center){
                        ForEach(model.buses){ item in
                            TransportWaiterView(object: item) { id  in
                                handlerTransport(routeId: id)
                            } handlerStop: { id in
                                handlerStop(stopId: id)
                            } handlerTime: { item in
                                handlerTime(item: item)
                            }

                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
                
                if(!model.trains.isEmpty){
                    LabelTypeTransport(typeTransport: .train)
                    Grid(alignment: .center){
                        ForEach(model.trains){ item in
                            TransportWaiterView(object: item) { id  in
                                handlerTransport(routeId: id)
                            } handlerStop: { id in
                                handlerStop(stopId: id)
                            } handlerTime: { item in
                                handlerTime(item: item)
                            }

                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
                
                if(!model.trolleybuses.isEmpty){
                    LabelTypeTransport(typeTransport: .trolleybus)
                    Grid(alignment: .center){
                        ForEach(model.trolleybuses){ item in
                            TransportWaiterView(object: item) { id  in
                                handlerTransport(routeId: id)
                            } handlerStop: { id in
                                handlerStop(stopId: id)
                            } handlerTime: { item in
                                handlerTime(item: item)
                            }

                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
                
                if(!model.countryBuses.isEmpty){
                    LabelTypeTransport(typeTransport: .countrybus)
                    Grid(alignment: .center){
                        ForEach(model.countryBuses){ item in
                            TransportWaiterView(object: item) { id  in
                                handlerTransport(routeId: id)
                            } handlerStop: { id in
                                handlerStop(stopId: id)
                            } handlerTime: { item in
                                handlerTime(item: item)
                            }

                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(10)
                }
            }
            .padding(.horizontal, 20)
            .opacity(model.opacity)
            .scrollIndicators(.hidden)
            
            Spacer()
            
        }
        .onAppear(){
            viewModel.getStationData()
        }
    }
    
    
    func handlerTransport(routeId: Int){
        navigationStack.append(CurrentTransportSelectionView.showRouteOnline(routeId))
        TransportGroupStackManager.shared.model.objectWillChange.send()
    }
    
    func handlerStop(stopId: Int){
        navigationStack.append(CurrentTransportSelectionView.showStopOnline(stopId))
        TransportGroupStackManager.shared.model.objectWillChange.send()
    }
    
    func handlerTime(item: TransportWaiter){
        AppTabBarViewModel.shared.chooseTimeAlert(time: item.time, type: item.type, route: item.transportNumber, stop: model.stopId)
    }
    
}

struct TransportWaiter: Identifiable{
    let id = UUID()
    let transportNumber: String
    let routeId: Int
    let type: TypeTransport
    let endStationName: String
    let stopId: Int
    let time: String
    var isLastSection = false
    var isFirstSection = false
}

struct TransportWaiterView: View {
    
    let object: TransportWaiter
    
    let handlerTransport: (Int) -> ()
    
    let handlerStop: (Int) -> ()
    
    let handlerTime: (TransportWaiter) -> ()
    
    var body: some View{
        VStack{
            
            if(object.isFirstSection){
                GeometryReader{_ in
                    
                }
                .frame(width: UIScreen.screenWidth-40, height: 1)
                .background(Color.white.opacity(0))
            }
            
            HStack{
                Button(action: {
                    handlerTransport(object.routeId)
                }, label: {
                    if(object.transportNumber.last!.isLetter){
                        ZStack{
                            Text(object.transportNumber)
                                .font(.title)
                                .foregroundColor(.blue)
                                .lineLimit(2)
                                .minimumScaleFactor(0.01)
                        }
                        .frame(width: UIScreen.screenWidth/7)
                    }else{
                        ZStack{
                            Text(object.transportNumber)
                                .font(.title)
                                .foregroundColor(.blue)
                                .lineLimit(1)
                        }
                        .frame(width: UIScreen.screenWidth/7)
                    }
                    
                })
                Button(action: {
                    handlerStop(object.stopId)
                }, label: {
                    Text(object.endStationName)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black.opacity(0.6))
                        .kerning(1)
                        .lineLimit(2)
                        .minimumScaleFactor(0.01)
                })
                Spacer()
                Button(action: {
                    if(object.time != "—"){
                        handlerTime(object)
                    }
                }, label: {
                    HStack(alignment: .firstTextBaseline){
                        Text(object.time)
                            .font(.title)
                            .foregroundColor(.black.opacity(0.6))
                        if(object.time != "—"){
                            Text("мин")
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.6))
                        }
                    }
                })
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 1)
            
            if(object.isLastSection){
                GeometryReader{_ in
                    
                }
                .frame(width: UIScreen.screenWidth-40, height: 1)
                .background(Color.black.opacity(0))
            }else{
                GeometryReader{_ in
                    
                }
                .frame(width: UIScreen.screenWidth-40, height: 1)
                .background(Color.black.opacity(0.6))
            }
            
            
            
        }
    }
}

struct ShowTransportStopView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        ShowTransportStopView(navigationStack: $stack, stopId: 335)
    }
}
