import SwiftUI

//struct CustomAlertModifier: ViewModifier {
//    // MARK: - Value
//    // MARK: Private
//    @Binding var isPresented: Bool
//
//    // MARK: Private
//    private let someAlert: CustomAlert
//
//    init(someAlert: CustomAlert, isPresented: Binding<Bool>) {
//        self.someAlert = someAlert
//
//        _isPresented = isPresented
//    }
//
//    func body(content: Content) -> some View {
//        ZStack{
//            content
//            if(isPresented){
//                someAlert
//                    .onDisappear(){
//                            isPresented.toggle()
//                    }
//            }
//        }
//    }
//
//}

