//
//  ShowTransportOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 09.02.2023.
//

import SwiftUI

struct ShowTransportRouteView: View {
    
    @State private var isMenuOpen = false
    @State private var currentDate = Date()
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @ObservedObject private var model = ShowTransportRouteModel()
    private var viewModel: ShowTransportRouteViewModel!
    
    init(navigationStack: Binding<NavigationPath>, routeId: Int){
        self._navigationStack = navigationStack
        self.viewModel = ShowTransportRouteViewModel(model: model)
        viewModel?.configureView(routeId: routeId)
    }
    
    var body: some View {
        ZStack{
            VStack{
                LabelOfStopOrRoute(name: model.name, isFavorite: $model.isFavorite, backTapp: {
                    dismiss()
                }, starTapp: {
                    viewModel.favoriteRouteTapped()
                })
                
                CustomMenu(menu: model.menu, isMenuOpen: $isMenuOpen, tappHandler: { item in
                    let newDirection = Direction(startStation: item.startStopId, endStation: item.endStopId)
                    
                    model.direction = newDirection
                    
                    viewModel.presentRoute(direction: newDirection)
                })
                .zIndex(1)
                
                ScrollView{
                    Grid(alignment: .trailing){
                        ForEach(model.data) { item in   
                            GridRow{
                                StopListRow(station: item, handlerTransportImageTapp: imageTransportTapped, handlerLabelStopTapp: labelStopTapped, handlerLabelTimeTapp: labelTimeTapped)
                            }
                        }
                    }
                    
                    if(model.status != nil){
                        HStack{
                            Text("ПОДРОБНОСТИ")
                                .opacity(0.8)
                                .font(.system(size: 14))
                                .opacity(0.8)
                                .lineLimit(1)
                                .padding(.horizontal, 20)
                                .minimumScaleFactor(0.01)
                                .padding(.vertical, 1)
                            
                            Spacer()
                        }
                        
                        VStack{
                            HStack{
                                Text(model.status!)
                                    .font(.system(size: 14))
                                    .opacity(0.8)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 1)
                            .kerning(1)
                        }
                        .padding(.vertical, 15)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    }
                }.scrollIndicators(.hidden)
            }
            .onTapGesture {
                isMenuOpen = false
            }
        }
        .onAppear(){
            if let direction = model.direction{
                viewModel.presentRoute(direction: direction)
            }else{
                viewModel.presentRoute()
            }
        }
    }
    
    func labelStopTapped(stopId: Int?){
        if let stopId = stopId{
            navigationStack.append(CurrentTransportSelectionView.showStopOnline(stopId))
            TransportGroupStackManager.shared.model.objectWillChange.send()
        }else{
            AppTabBarViewModel.shared.showAlert(title: "Нет данных", message: "Не удалось найти данные по этой остановке")
        }
    }
    
    func imageTransportTapped(transportId: String?){
        if let transportId = transportId{
            navigationStack.append(CurrentTransportSelectionView.showTransportUnit(transportId))
            TransportGroupStackManager.shared.model.objectWillChange.send()
        }else{
            AppTabBarViewModel.shared.showAlert(title: "Нет данных", message: "Не удалось найти данные по этому транспортному средству")
        }
    }
    
    func labelTimeTapped(stop: Stop){
        
        AppTabBarViewModel.shared.chooseTimeAlert(time: stop.time, type: model.type, route: model.number, stop: stop.id)
    }
    
}

struct ShowRouteOnline_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        ShowTransportRouteView(navigationStack: $stack, routeId: 14)
    }
}

