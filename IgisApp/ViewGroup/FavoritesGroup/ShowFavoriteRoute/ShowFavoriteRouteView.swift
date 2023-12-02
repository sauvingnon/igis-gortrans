//
//  FavoriteStopOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.02.2023.
//

import SwiftUI

struct ShowFavoriteRouteView: View {
    
    @State var isMenuOpen = false
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentFavoritesSelectionView]
    
    @ObservedObject var model = ShowFavoriteRouteModel.shared
    private let viewModel = ShowFavoriteRouteViewModel.shared
    
    @State var sizeStar = 1.0
    @State var scaleBack = 1.0
    
    var body: some View {
        VStack{
            LabelSomeTransport(name: model.name, isFavorite: $model.isFavorite, backTapp: {
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
                    ForEach(model.data, id: \.self) { item in
                        GridRow{
                            StationRow(station: item, handlerTransportImageTapp: imageTransportTapped, handlerLabelStopTapp: labelStopTapped)
                        }
                    }
                }
            }.scrollIndicators(.hidden)
            
            Spacer()
        }.onTapGesture {
            isMenuOpen = false
        }
    }
    
    func labelStopTapped(stopId: Int?){
//        ShowTransportStopViewModel.shared.configureView(stop_id: stopId ?? 0)
//        navigationStack.append(.showStopOnline)
    }
    
    func imageTransportTapped(transportId: String?){
//        ShowTransportUnitViewModel.shared.configureView(transportId: transportId)
//        navigationStack.append(.showTransportOnline)
    }
    
}
    
//    struct FavoriteTransportOnline_Previews: PreviewProvider {
//        static var previews: some View {
//            FavoriteTransportOnline()
//        }
//    }

extension ShowFavoriteRouteView{
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
