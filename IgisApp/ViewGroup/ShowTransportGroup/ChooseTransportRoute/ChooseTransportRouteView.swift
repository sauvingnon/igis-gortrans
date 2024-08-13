//
//  SelectNumTSView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.11.2022.
//

import SwiftUI

struct ChooseTransportRouteView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @ObservedObject var configuration = ChooseTransportRouteModel.shared
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(){
            LabelIzhevsk(withBackButton: true, stack: $navigationStack)
            {
                dismiss()
            }
            
            ScrollView(.vertical, showsIndicators: false){
                TableOfRouteWithType(typeTransport: configuration.type, arrayNumbers: configuration.numArray, handlerFunc: chooseHandler(number:type:))
            }
            
            Spacer()
        }
        
    }
    
    func chooseHandler(number: String, type: TypeTransport){
        let routeId = DataBase.getRouteId(type: type, number: number)
        navigationStack.append(CurrentTransportSelectionView.showRouteOnline(routeId))
        
    }
    
}

struct ChooseTransportRouteView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        ChooseTransportRouteView(navigationStack: $stack)
    }
}
