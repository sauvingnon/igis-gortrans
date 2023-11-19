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
    @Binding var navigationStack: [CurrentTransportSelectionView]
    
    @ObservedObject var model = ShowTransportUnitModel.shared
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.843599,
            longitude: 53.202824),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1))
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                VStack{
                    Text("Автобус \(model.transportNumber ?? "-")")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
            }
            .onTapGesture {
                dismiss()
            }
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.top, 10)
            
            if(model.showIndicator){
                ProgressView()
            }
            
            ScrollView{
                
                HStack{
                    Text("Маршрут \(model.routeNumber ?? "-")")
                        .foregroundColor(.gray)
                        .kerning(1)
                        .padding(.horizontal, 10)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Text("\(model.startStation ?? "") - \(model.endStation ?? "")")
                    .opacity(0.8)
                    .lineLimit(1)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(0.01)
                    .padding(.vertical, 1)
                
//                ScrollView{
                    Grid(alignment: .trailing){
                        ForEach(model.data) { item in
                            GridRow{
                                StationRow(station: item, handlerTransportImageTapp: {_ in }, handlerLabelStopTapp: {_ in })
                                    .onTapGesture(count: 1){
                                        
                                    }
                                //                                    .swipeActions(edge: .trailing, allowsFullSwipe: true){
                                //                                        Button {
                                //                                            print("Message deleted")
                                //                                        } label: {
                                //                                            Label("Delete", systemImage: "trash")
                                //                                        }
                                //                                    }
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
                
                Map(coordinateRegion: $region, annotationItems: model.locations){ location in
                    MapAnnotation(coordinate: location.coordinate){
                        Image(systemName: location.icon)
                            .resizable()
                            .foregroundColor(.white)
                            .padding(3)
                            .background(Color.blue)
                            .cornerRadius(50)
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
        .onDisappear(){
            ShowTransportUnitViewModel.shared.unsubscribe()
        }
    }
}

//struct ShowTransportOnline_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowTransportOnline()
//    }
//}
