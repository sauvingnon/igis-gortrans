//
//  ShowTransportOnline.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.06.2023.
//

import SwiftUI
import MapKit

struct ShowTransportOnline: View {
    
    @EnvironmentObject var coordinator: coordinatorTransport
    
    @ObservedObject var configuration = ConfigurationTransport()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.843599,
            longitude: 53.202824),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1))
    
//    @State private var array = [
//        Station(id: 1, name: "Механизаторская улица", stationState: .startStation, pictureTs: "", time: "1 мин"),
//        Station(id: 2, name: "Южные электросети", stationState: .someStation, pictureTs: "", time: "3 мин"),
//        Station(id: 3, name: "Московская улица", stationState: .someStation, pictureTs: "", time: "4 мин"),
//        Station(id: 4, name: "Железнодорожный вокзал", stationState: .someStation, pictureTs: "", time: "6 мин"),
//        Station(id: 5, name: "Планерная улица", stationState: .someStation, pictureTs: "", time: "7 мин"),
//        Station(id: 6, name: "Улица Гагарина", stationState: .someStation, pictureTs: "", time: "10 мин"),
//        Station(id: 7, name: "Автопарк №1", stationState: .someStation, pictureTs: "", time: "12 мин"),
//        Station(id: 8, name: "Администрация Ленинского района", stationState: .endStation, pictureTs: "", time: "18 мин"),]
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                VStack{
                    Text("Автобус \(configuration.transportNumber ?? "-")")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
            }
            .onTapGesture {
                coordinator.show(view: .showRouteOnline)
            }
            .frame(width: UIScreen.screenWidth - 40, height: 50, alignment: .leading)
            .background(Color.blue)
            .clipShape(Rectangle())
            .cornerRadius(25)
            .padding(.top, 10)
            
            if(configuration.showIndicator){
                ProgressView()
            }
            
            ScrollView{
                
                HStack{
                    Text("Маршрут \(configuration.routeNumber ?? "-")")
                        .foregroundColor(.gray)
                        .kerning(1)
                        .padding(.horizontal, 10)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Text("\(configuration.startStation ?? "") - \(configuration.endStation ?? "")")
                    .opacity(0.8)
                    .lineLimit(1)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(0.01)
                    .padding(.vertical, 1)
                
//                ScrollView{
                    Grid(alignment: .trailing){
                        ForEach(configuration.data) { item in
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
                        Text("\(configuration.priceCash)₽ наличными")
                            .opacity(0.8)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 1)
                    .kerning(1)
                    
                    HStack{
                        Text("\(configuration.priceCard)₽ банковской картой")
                            .opacity(0.8)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 1)
                    .kerning(1)
                    
                    HStack{
                        Text("\(configuration.priceTransportCard)₽ транспортной картой")
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
                
                Map(coordinateRegion: $region, annotationItems: configuration.locations){ location in
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
                            Text("\(configuration.timeWord ?? "--:--")")
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
            .opacity(configuration.opacity)
        }
    }
    
    
    func configureView(transportId: String?){
        if(transportId == nil){
            return
        }
        configuration.transportId = transportId!
        Model.PresentTransport(configuration: configuration)
    }
}

struct ShowTransportOnline_Previews: PreviewProvider {
    static var previews: some View {
        ShowTransportOnline()
    }
}

@MainActor
class ConfigurationTransport: ObservableObject {
    @Published var opacity = 1.0
    @Published var showIndicator = false
    var transportId = ""
    var oldCoordinatorView: CurrentTransportSelectionView = .showRouteOnline
    var data: [Station] = []
    var priceCash = 0
    var priceCard = 0
    var priceTransportCard = 0
    var routeNumber: String?
    var transportNumber: String?
    var startStation: String?
    var endStation: String?
    var transportModel: String?
    var timeWord: String?
    var maintenance: String?
    var currentStopId: Int = 0
    
    @Published var locations: [Location] = []
    
    func showData(){
        showIndicator = false
        withAnimation{
            opacity = 1
        }
        self.objectWillChange.send()
    }
    
    struct Location: Identifiable{
        let id = UUID()
        let name: String
        let icon: String
        let coordinate: CLLocationCoordinate2D
    }
}
