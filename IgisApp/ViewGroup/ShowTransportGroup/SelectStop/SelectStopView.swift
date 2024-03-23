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
                dismiss()
            }
            
            TextField("Поиск остановки", text: $searchText)
                .padding(.horizontal, 20)
                .focused($searchIsFocuced)
            
            Divider()
                .frame(width: UIScreen.screenWidth - 40, height: 1)
                .background(Color.gray)
            
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
            HStack{
                if(stop.typeTransportList.contains(.bus)){
                    Image("bus_icon")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                if(stop.typeTransportList.contains(.countrybus)){
                    Image("bus_icon")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                if(stop.typeTransportList.contains(.train)){
                    Image("train_icon")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                if(stop.typeTransportList.contains(.trolleybus)){
                    Image("trolleybus_icon")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                Text(stop.stopName)
                    .foregroundColor(.blue)
                    .bold()
                Text("—")
                    .foregroundColor(.blue)
                Text(stop.stopDirection)
                    .foregroundColor(.blue)
                if let distance = stop.distance{
                    Text("\(distance) м")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
                
            }
        })
    }
}

struct SelectStopView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath([CurrentTransportSelectionView]())
    
    static var previews: some View {
        SelectStopView(navigationStack: $stack)
    }
}
