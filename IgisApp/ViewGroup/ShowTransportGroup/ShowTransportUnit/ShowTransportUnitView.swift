//
//  ShowTransportOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.06.2023.
//

import SwiftUI
import MapKit

struct ShowTransportUnitView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @ObservedObject var model = ShowTransportUnitModel()
    private var viewModel: ShowTransportUnitViewModel!
    
    init(navigationStack: Binding<NavigationPath>, transportId: String){
        self._navigationStack = navigationStack
        self.viewModel = ShowTransportUnitViewModel(model: model)
        viewModel.configureView(transportId: transportId)
    }
    
    var body: some View {
        VStack{
            LabelOfTransportUnit(transportUnitDescription: model.transportUnitDescription, handlerFunc: {
                dismiss()
            })
            
            if(model.showIndicator){
                ProgressView()
            }
            
            ScrollView{
                
                HStack{
                    Text("Маршрут \(model.routeNumber ?? "—")")
                        .foregroundColor(.gray)
                        .kerning(1)
                        .padding(.horizontal, 10)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                HStack{
                    Text("\(model.startStation ?? "") - \(model.endStation ?? "")")
                        .foregroundColor(.gray)
                        .kerning(1)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 1)
                
                    
                    
                
//                ScrollView{
                    Grid(alignment: .trailing){
                        ForEach(model.data) { item in
                            GridRow{
                                StopListRow(station: item, handlerTransportImageTapp: { transportId in
                                    navigationStack.append(CurrentTransportSelectionView.showTransportUnit(transportId ?? ""))
                                }, handlerLabelStopTapp: { stopId in
                                    navigationStack.append(CurrentTransportSelectionView.showStopOnline(stopId ?? 0))
                                }, handlerLabelTimeTapp: { time in
                                    AppTabBarViewModel.shared.chooseTimeAlert(time: item.time, type: model.transportType, route: model.routeNumber ?? "-", stop: item.id)
                                })
                            }
                        }
                    }
                    .padding(.horizontal, 20)
//                }
//                .scrollIndicators(.hidden)
//                .frame(width: UIScreen.screenWidth-40, height: UIScreen.screenHeight/3)
                
                HStack{
                    Text("СТОИМОСТЬ ПРОЕЗДА")
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
                        Text("\(model.priceCash)₽ наличными")
                            .opacity(0.8)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 1)
                    .kerning(1)
                    
                    HStack{
                        Text("\(model.priceCard)₽ банковской картой")
                            .opacity(0.8)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 1)
                    .kerning(1)
                    
                    HStack{
                        Text("\(model.priceTransportCard)₽ транспортной картой")
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
                
                HStack{
                    Text("МАРШРУТ НА КАРТЕ")
                        .opacity(0.8)
                        .font(.system(size: 14))
                        .opacity(0.8)
                        .lineLimit(1)
                        .padding(.horizontal, 20)
                        .minimumScaleFactor(0.01)
                        .padding(.vertical, 1)
                    Spacer()
                }
                
                Map(coordinateRegion: $model.region, annotationItems: model.locations){ location in
                    MapAnnotation(coordinate: location.coordinate){
                        MapItem(transportAnnotation: TransportAnnotation(icon: location.icon, color: location.color, type: location.type, finish_stop: location.finish_stop, current_stop: location.current_stop, route: location.route, ts_id: location.ts_id, inPark: location.inPark, gosnumber: location.gosnumber, azimuth: location.azimuth, coordinate: location.coordinate))
                    }
                    
                }
                .frame(width: UIScreen.screenWidth-40, height: UIScreen.screenWidth-40)
                .cornerRadius(30)
                .padding(.bottom, 20)
                
                HStack{
                    Text("ПОДРОБНЕЕ")
                        .opacity(0.8)
                        .font(.system(size: 14))
                        .opacity(0.8)
                        .lineLimit(1)
                        .padding(.horizontal, 20)
                        .minimumScaleFactor(0.01)
                        .padding(.vertical, 1)
                    Spacer()
                }
                
                HStack(alignment: .top){
                    VStack{
                        HStack{
                            Text("Модель ТС:")
                                .opacity(0.8)
                            Spacer()
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 1)
                        .kerning(1)
                        HStack{
                            Text("На рейсе:")
                                .opacity(0.8)
                            Spacer()
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 1)
                        .kerning(1)
                        HStack{
                            Text("Обслуживается:")
                                .opacity(0.8)
                            Spacer()
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 1)
                        .kerning(1)
                    }
                    VStack{
                        HStack{
                            Text("МАЗ-103486")
                                .opacity(0.8)
                            Spacer()
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 1)
                        .kerning(1)
                        HStack{
                            Text("\(model.timeWord ?? "--:--")")
                                .opacity(0.8)
                            Spacer()
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 1)
                        .kerning(1)
                        HStack{
                            Text("Автотранспортное предприятие №2")
                                .opacity(0.8)
                            Spacer()
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 1)
                        .kerning(1)
                    }
                }
                .padding(.vertical, 15)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                Spacer()
            }
            .opacity(model.opacity)
        }
        .onAppear(){
            viewModel.getTransportData()
        }
    }
}

struct ShowTransportUnitView_Preview: PreviewProvider {
    
    @State static var path = NavigationPath()
    
    static var previews: some View {
        ShowTransportUnitView(navigationStack: $path, transportId: "")
    }
}
