//
//  SelectStopView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct SelectStopView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @State var searchText = ""
    @FocusState private var searchIsFocuced: Bool
    
    private let viewModel = SelectStopViewModel.shared
    
    var columns: [GridItem] = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            LabelIzhevsk(withBackButton: true, stack: $navigationStack)
            {
                searchIsFocuced = false
                dismiss()
            }
            
            HStack{
                TextField("Поиск", text: $searchText)
                    .focused($searchIsFocuced)
                    .padding(.leading, 5)
                Button(action: {
                    searchIsFocuced = false
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.trailing, 5)
                })
            }
            .padding(7)
            .background(.gray.opacity(0.15))
            .cornerRadius(12.0)
            .padding(.horizontal, 20)
            
            ScrollView{
                LazyVGrid(columns: columns, alignment: .leading){
                    ForEach(viewModel.fillStopList(searchText: searchText)) { item in
                        GridRow{
                            StopRowView(stop: item, handlerFunc: stopTapped)
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                    }
                }
                .animation(.default, value: searchText)
            }
            //            .scrollIndicators(.hidden)
            
        }
        .onTapGesture {
            searchIsFocuced = false
        }
        .onAppear(){
            ServiceSocket.shared.emitOff()
        }
    }
    
    private func stopTapped(stop_id: Int){
        ShowTransportStopViewModel.shared.configureView(stop_id: stop_id)
        navigationStack.append(CurrentTransportSelectionView.showStopOnline)
    }
}

struct StopRowView: View {
    
    @State var stop: StopItem
    var handlerFunc: (Int) -> ()
    var body: some View {
        Button(action: {
            handlerFunc(stop.stop_id)
        }, label: {
            VStack{
                HStack{
                    Text(stop.stopName)
                        .font(.headline)
                        .foregroundStyle(.blue.opacity(1))
                        .multilineTextAlignment(.leading)
                        
                    if(stop.typeTransportList.contains(.bus)){
                        Image("bus_icon_green")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    if(stop.typeTransportList.contains(.countrybus)){
                        Image("bus_icon_green")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    if(stop.typeTransportList.contains(.train)){
                        Image("train_icon_red")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    if(stop.typeTransportList.contains(.trolleybus)){
                        Image("trolleybus_icon_blue")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    
                    Spacer()
                }
                HStack{
                    Text(stop.stopDirection)
                        .font(.footnote)
                        .foregroundStyle(.blue.opacity(0.7))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    if let distance = stop.distance{
                        Text("\(distance) м")
                            .font(.footnote)
                            .foregroundStyle(.blue.opacity(0.7))
                    }
                }
                GeometryReader{ geometry in
                    
                }
                .frame(height: 1)
                .background(.blue.opacity(0.5))
            }
//            HStack{
//                if(stop.typeTransportList.contains(.bus)){
//                    Image("bus_icon_green")
//                        .resizable()
//                        .frame(width: 25, height: 25)
//                }
//                if(stop.typeTransportList.contains(.countrybus)){
//                    Image("bus_icon_green")
//                        .resizable()
//                        .frame(width: 25, height: 25)
//                }
//                if(stop.typeTransportList.contains(.train)){
//                    Image("train_icon_red")
//                        .resizable()
//                        .frame(width: 25, height: 25)
//                }
//                if(stop.typeTransportList.contains(.trolleybus)){
//                    Image("trolleybus_icon_blue")
//                        .resizable()
//                        .frame(width: 25, height: 25)
//                }
//                Text(stop.stopName)
//                    .foregroundColor(.blue)
//                    .bold()
//                Text("—")
//                    .foregroundColor(.blue)
//                Text(stop.stopDirection)
//                    .foregroundColor(.blue)
//                if let distance = stop.distance{
//                    Text("\(distance) м")
//                        .foregroundColor(.blue)
//                        .font(.title3)
//                }
//                
//            }
        })
    }
}

struct SelectStopView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath([CurrentTransportSelectionView]())
    
    static var previews: some View {
        SelectStopView(navigationStack: $stack)
    }
}
