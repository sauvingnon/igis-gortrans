//
//  ShowTransportOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 09.02.2023.
//

import SwiftUI

struct ShowTransportRouteView: View {
    
    @State private var isMenuOpen = false
    @State private var sizeStar = 1.0
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
                
                customMenu(menu: model.menu)
                    .zIndex(1)
                    .onChange(of: model.menu.currentStop, perform: { newValue in
                        let newDirection = Direction(startStation: newValue.startStopId, endStation: newValue.endStopId)
                        
                        viewModel.presentRoute(direction: newDirection)
                    })
                
                ScrollView{
                    Grid(alignment: .trailing){
                        ForEach(model.data) { item in   
                            GridRow{
                                StationRow(station: item, handlerTransportImageTapp: imageTransportTapped, handlerLabelStopTapp: labelStopTapped)
                            }
                        }
                    }
                }.scrollIndicators(.hidden)
                
                Spacer()
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

struct StationRow: View{
    var station: Station
    var handlerTransportImageTapp: (String?) -> ()
    var handlerLabelStopTapp: (Int?) -> ()
    var body: some View{
        HStack{
            Text(station.name)
                .foregroundColor(.blue)
                .fontWeight(.light)
                .lineLimit(2)
                .onTapGesture {
                    labelStopTapped()
                }
            switch(station.stationState){
            case .endStation:
                Image("endStation")
                    .resizable()
                    .frame(width: 30, height: 50)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 30)
            case .someStation:
                Image("someStation")
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
            
            if(!station.pictureTs.isEmpty && !station.isNext){
                HStack{
                    Image(systemName: station.pictureTs)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            imageTransportTapped()
                        }
                }
                .frame(width: 50, height: 50)
                }else{
                    if(station.isNext){
                        VStack{
                            HStack(alignment: .top){
                                Image(systemName: station.pictureTs)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.blue)
                                    .frame(width: 20, height: 20)
                                    .onTapGesture {
                                        imageTransportTapped()
                                    }
                            }
                            .frame(width: 50, height: 50)
                            .offset(y: +7)
                            
                            Text(station.time)
                                .frame(width: 50, height: 50)
                                .lineLimit(1)
                                .minimumScaleFactor(0.01)
                                .offset(y: -30)
                                .foregroundColor(.gray)
                    
                        }
                        .frame(width: 50, height: 50)
                    }else{
                        Text(station.time)
                            .frame(width: 50, height: 50)
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(.gray)
                    }
                }
        }
        .frame(height: 35)
    }
    
    func imageTransportTapped() {
        handlerTransportImageTapp(station.transportId)
    }
    
    func labelStopTapped() {
        handlerLabelStopTapp(station.id)
    }
}

struct Station: Identifiable, Hashable {
    let id: Int
    let name: String
    let stationState: StationState
    var pictureTs: String
    let time: String
    var isNext: Bool
    var transportId: String?
    init(id: Int, name: String, stationState: StationState, pictureTs: String, time: String, isNext: Bool = false, transportId: String? = nil) {
        self.isNext = isNext
        self.id = id
        self.name = name
        self.stationState = stationState
        self.pictureTs = pictureTs
        self.time = time
        self.transportId = transportId
    }
    // Ячейки можем пересоздать, тогда вью обновится
}

extension ShowTransportRouteView{
    func customMenu(menu: Menu) -> some View {
        return ZStack {
            ForEach(menu.menuItems, id: \.self){ item in
                ZStack {
                    HStack{
                        Text("\(DataBase.getStopName(stopId: item.startStopId)) - \(DataBase.getStopName(stopId: item.endStopId))")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: UIScreen.screenWidth - 80)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Rectangle())
                    .cornerRadius(25)
                    .onTapGesture {
                        menu.currentStop = item
                        isMenuOpen.toggle()
                    }
                    .padding(.horizontal, 20)
                }
                .shadow(color: .black.opacity(isMenuOpen ? 0.1 : 0.0), radius: 10, x: 0, y: 5)
                .offset(y: isMenuOpen ? CGFloat(item.offset) : 0)
                .opacity(isMenuOpen ? 100 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5), value: isMenuOpen)
            }
            
            ZStack {
                HStack{
                    Text("\(DataBase.getStopName(stopId: menu.currentStop.startStopId)) - \(DataBase.getStopName(stopId: menu.currentStop.endStopId))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                    
                    Image(systemName: isMenuOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
                }
                .frame(minWidth: UIScreen.screenWidth-40)
                .padding(10)
                .background(Color.blue)
                .clipShape(Rectangle())
                .cornerRadius(25)
                .padding(.horizontal, 20)
            }
            .onTapGesture {
                isMenuOpen.toggle()
            }
            
        }
    }
}

