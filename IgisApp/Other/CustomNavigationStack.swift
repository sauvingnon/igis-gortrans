//
//  CustomNavigationStack.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 25.01.2024.
//

import SwiftUI

struct CustomNavigationStack<Content: View>: View {
    
    @Binding var path: NavigationPath
    
    @ViewBuilder var content: Content
    
    // Полный свайп кастомный жест
    
    @State private var customGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = UUID().uuidString
        gesture.isEnabled = true
        return gesture
    }()
    
    var body: some View {
        NavigationStack(path: $path){
            content
                .background{
                    AttachGestureView(gesture: $customGesture)
                }
        }
        .environment(\.popGestureID, customGesture.name)
//        .onReceive(NotificationCenter.default.publisher(for: .init(customGesture.name ?? "")), perform: { info in
//            if let userInfo = info.userInfo, let status = userInfo["status"] as? Bool {
//                customGesture.isEnabled = status
//            }
//        })
    }
}

fileprivate struct PopNotificationID: EnvironmentKey {
    static var defaultValue: String?
}

fileprivate extension EnvironmentValues {
    var popGestureID: String? {
        get {
            self[PopNotificationID.self]
        }
        
        set {
            self[PopNotificationID.self] = newValue
        }
    }
}

extension View {
    @ViewBuilder func enableFullSwipePop(_ isEnabled: Bool) -> some View{
        self
            .modifier(FullSwipeModifier(isEnabled: isEnabled))
    }
}

fileprivate struct FullSwipeModifier: ViewModifier {
    
    var isEnabled: Bool
    @Environment(\.popGestureID) private var gestureID
    func body(content: Content) -> some View {
        content
//            .onChange(of: isEnabled, initial: true){ oldValue, newValue in
//                print(gestureID)
//            }
    }
}

// Файлы - помощники
fileprivate struct AttachGestureView: UIViewRepresentable {
    @Binding var gesture: UIPanGestureRecognizer
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02){
            // Найти контроллер - партнер
            if let parentViewController = uiView.parentViewController {
                if let navigationController = parentViewController.navigationController{
                    // Проверка если жест уже был добавлен на контроллер
                    if let _ = navigationController.view.gestureRecognizers?.first(where: {
                        $0.name == gesture.name
                    }){
                        print("Жест уже добавлен на контроллер")
                    }else{
                        navigationController.addFullSwipeGesture(gesture)
                        print("Жест добавлен")
                    }
                }
            }
        }
    }
}

fileprivate extension UINavigationController {
    // Добавление кастомного жеста полного свайпа
    func addFullSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureSelector = interactivePopGestureRecognizer?.value(forKey: "targets") else { return }
        
        gesture.setValue(gestureSelector, forKey: "targets")
        view.addGestureRecognizer(gesture)
    }
}

fileprivate extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self){
            $0.next
        }.first(where: { $0 is UIViewController }) as? UIViewController
    }
}

//#Preview {
//    CustomNavigationStack()
//}
