//
//  SelectStopView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 20.02.2023.
//

import SwiftUI

struct SelectStopView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: [CurrentTransportSelectionView]
    
    @State var searchText = ""
    @FocusState private var searchIsFocuced: Bool
    
    @ObservedObject var model = SelectStopModel.shared
    private let viewModel = SelectStopViewModel.shared
    
    var columns: [GridItem] = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            LabelIzhevsk(withBackButton: true)
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
                    ForEach(model.stopsList) { item in
                        GridRow{
                            StopRowView(stop: item)
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            ShowTransportStopViewModel.shared.configureView(stop_id: item.stop_id)
                            navigationStack.append(.showStopOnline)
                        }
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
}

struct StopRowView: View {
    
    @State var stop: StopItem

    var body: some View {
        HStack{
            if(stop.typeTransportList.contains(.bus)){
                Image("bus_icon")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            if(stop.typeTransportList.contains(.countrybus)){
                Image("bus_icon")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            if(stop.typeTransportList.contains(.train)){
                Image("train_icon")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            if(stop.typeTransportList.contains(.trolleybus)){
                Image("trolleybus_icon")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            Text(stop.stopName)
                .foregroundColor(.blue)
                .bold()
            Text("-")
                .foregroundColor(.blue)
            Text(stop.stopDirection)
                .foregroundColor(.blue)
            
        }
    }
}

struct SelectStopView_Previews: PreviewProvider {
    
    @State static var stack: [CurrentTransportSelectionView] = [.selectStopView]
    
    static var previews: some View {
        SelectStopView(navigationStack: $stack)
    }
}
