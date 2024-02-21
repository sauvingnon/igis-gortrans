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
    
    @ObservedObject private var model = ShowTransportRouteModel.shared
    private let viewModel = ShowTransportRouteViewModel.shared
    
    var body: some View {
        ZStack{
            VStack{
                LabelOfStopOrRoute(name: model.name, isFavorite: $model.isFavorite, backTapp: {
                    dismiss()
                }, starTapp: {
                    viewModel.favoriteRouteTapped()
                })
                
                CustomMenu(menu: model.menu, isMenuOpen: $isMenuOpen)
                    .zIndex(1)
                    .onChange(of: model.menu.currentStop, perform: { newValue in
                        let newDirection = Direction(startStation: newValue.startStopId, endStation: newValue.endStopId)
                        
                        viewModel.presentRoute(direction: newDirection)
                    })
                
                ScrollView{
                    Grid(alignment: .trailing){
                        ForEach(model.data) { item in   
                            GridRow{
                                StopListRow(station: item, handlerTransportImageTapp: imageTransportTapped, handlerLabelStopTapp: labelStopTapped, handlerLabelTimeTapp: labelTimeTapped)
                            }
                        }
                    }
                    
                    if(model.status != "-"){
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
                                Text(model.status)
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
            
            if(model.alertIsPresented){
                model.alert
            }
            
        }
        .onAppear(){
            viewModel.presentRoute()
        }
    }
    
    func labelStopTapped(stopId: Int?){
        ShowTransportStopViewModel.shared.configureView(stop_id: stopId ?? 0)
        navigationStack.append(CurrentTransportSelectionView.showStopOnline)
    }
    
    func imageTransportTapped(transportId: String?){
        ShowTransportUnitViewModel.shared.configureView(transportId: transportId)
        navigationStack.append(CurrentTransportSelectionView.showTransportUnit)
    }
    
    func labelTimeTapped(time: String){
        
    }
    
    func showAlert(){
        model.alert = ChooseTimeAlert(isPresented: $model.alertIsPresented, currentTime: $currentDate)
        DispatchQueue.main.async {
            model.alertIsPresented = true
        }
    }
    
}

struct ShowRouteOnline_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        ShowTransportRouteView(navigationStack: $stack)
    }
}

