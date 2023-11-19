import SwiftUI

struct ChooseTimeAlert: View {

    @Binding var isPresented: Bool
    
    // MARK: - Value
    // MARK: Public
    @Binding var currentTime: Date
    
    // MARK: Private
    @State private var opacity: CGFloat           = 0
    @State private var backgroundOpacity: CGFloat = 0
    @State private var scale: CGFloat             = 0.001

    @Environment(\.dismiss) private var dismiss


    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            dimView
    
            alertView
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .task {
            animate(isShown: true)
        }
    }

    // MARK: Private
    private var alertView: some View {
        VStack(spacing: 20) {
            DatePicker("Время уведомления", selection: $currentTime, displayedComponents: .hourAndMinute)
            HStack(spacing: 20){
                Button("OK") {
                    debugPrint("Time was choosed")
                    let now = Date()
                    if(currentTime < now){
                        return
                    }
                    let count = Calendar.current.dateComponents([.second], from: now, to: currentTime).second
                    ChatModel.shared.sendMessage(currentMessage: Message(title: "Тест тест", content: "Было сделано в \(now), для \(currentTime)", dateTime: DateTime()), countTime: Double(count!))
                    isPresented = false
                    dismiss()
                }
                Button("Отмена") {
                    debugPrint("Time was choosed")
                    isPresented = false
                    dismiss()
                }
            }
            
        }
        .padding(24)
        .frame(width: 320)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 12)
    }

    private var dimView: some View {
        Color.gray
            .opacity(0.88)
            .opacity(backgroundOpacity)
    }


    // MARK: - Function
    // MARK: Private
    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        switch isShown {
        case true:
            opacity = 1
    
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
                backgroundOpacity = 1
                scale             = 1
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?()
            }
    
        case false:
            withAnimation(.easeOut(duration: 0.2)) {
                backgroundOpacity = 0
                opacity           = 0
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
        }
    }
}

