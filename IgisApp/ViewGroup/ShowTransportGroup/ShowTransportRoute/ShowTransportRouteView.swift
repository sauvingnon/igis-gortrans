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
    
    @StateObject private var viewModel = ShowTransportRouteViewModel()
    
    private let routeId: Int
    
    init(navigationStack: Binding<NavigationPath>, routeId: Int){
        debugPrint("Инициализирован ShowTransportRouteView")
        self._navigationStack = navigationStack
        self.routeId = routeId
    }
    
    var body: some View {
        ZStack{
            VStack{
                LabelOfStopOrRoute(name: viewModel.model.name, isFavorite: $viewModel.model.isFavorite, backTapp: {
                    dismiss()
                }, starTapp: {
                    viewModel.favoriteRouteTapped()
                })
                
                CustomMenu(menu: viewModel.model.menu, isMenuOpen: $isMenuOpen, tappHandler: { item in
                    let newDirection = Direction(startStation: item.startStopId, endStation: item.endStopId)
                    
                    viewModel.model.direction = newDirection
                    
                    viewModel.presentRoute(direction: newDirection)
                })
                .zIndex(1)
                
                ScrollView{
                    Grid(alignment: .trailing){
                        ForEach(viewModel.model.data) { item in
                            GridRow{
                                StopListRow(station: item, handlerTransportImageTapp: imageTransportTapped, handlerLabelStopTapp: labelStopTapped, handlerLabelTimeTapp: labelTimeTapped)
                            }
                        }
                    }
                    
                    if(viewModel.model.status != nil){
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
                                Text(viewModel.model.status!)
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
                    
                    Button(action: {
                        viewModel.showStopOnMap()
                    }, label: {
                        Text("Показать на карте")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                            .kerning(0.7)
                            .padding(8)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(15)
                    })
                    
                }.scrollIndicators(.hidden)
            }
            .onTapGesture {
                isMenuOpen = false
            }
            .onAppear(){
                
                viewModel.configureView(routeId: routeId)
                
                if let direction = viewModel.model.direction{
                    viewModel.fillMenu(direction: direction)
                    viewModel.presentRoute(direction: direction)
                }else{
                    viewModel.fillMenu()
                    viewModel.presentRoute()
                }
            }
            .onDisappear(){
                viewModel.eraseCallBack()
            }
        }
    }
    
    func labelStopTapped(stopId: Int?){
        if let stopId = stopId{
            navigationStack.append(CurrentTransportSelectionView.showStopOnline(stopId))
            
        }else{
            AppTabBarViewModel.shared.showAlert(title: "Нет данных", message: "Не удалось найти данные по этой остановке")
        }
    }
    
    func imageTransportTapped(transportId: String?){
        if let transportId = transportId{
            navigationStack.append(CurrentTransportSelectionView.showTransportUnit(transportId))
            
        }else{
            AppTabBarViewModel.shared.showAlert(title: "Нет данных", message: "Не удалось найти данные по этому транспортному средству")
        }
    }
    
    func labelTimeTapped(stop: Stop){
        AppTabBarViewModel.shared.chooseTimeAlert(time: stop.time, type: viewModel.model.type, route: viewModel.model.number, stop: stop.id)
    }
    
}

struct ShowRouteOnline_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        ShowTransportRouteView(navigationStack: $stack, routeId: 14)
    }
}

