import SwiftUI

struct ChooseTimeAlert: View {

    @Binding var isPresented: Bool
    let stop: String
    let transport: String
    let minCount: Int
    @State private var success = false
    @State private var failureText = ""
    
    // MARK: - Value
    // MARK: Public
    @State private var currentTime = Date()
    
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
        .onAppear(){
            currentTime = currentTime.addingTimeInterval(TimeInterval(minCount * 60))
        }
    }

    // MARK: Private
    private var alertView: some View {
        VStack(spacing: 10) {
            if(success){
                Text("Уведомление создано успешно!")
                    .multilineTextAlignment(.center)
                    .font(.title3)
            }else{
                Text("Уведомим, когда \(transport) будет подъезжать к \(stop)")
                    
                Text("Транспорт будет на остановке через \(minCount) мин")
                    .font(.caption)
                DatePicker("Время уведомления", selection: $currentTime, displayedComponents: .hourAndMinute)
                    .padding(.vertical, 20)
                if(!failureText.isEmpty){
                    Text(failureText)
                        .foregroundStyle(.red)
                }
                HStack(spacing: 20){
                    Button(action: {
                        buttonOkTapped()
                    }, label: {
                        Text("OK")
                            .padding(10)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    Button(action: {
                        isPresented = false
                        dismiss()
                    }, label: {
                        Text("Отмена")
                            .padding(10)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                }
            }
        }
        .padding(24)
        .frame(width: 320)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 12)
    }
    
    func buttonOkTapped(){
        let now = Date()
        let count = Calendar.current.dateComponents([.second], from: now, to: currentTime).second
        if(currentTime < now && count ?? 0 < 0){
            failureText = "Некорретный ввод времени"
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        
        let timeString = formatter.string(from: currentTime)
        
        formatter.dateFormat = "dd MMMM, yyyy"
        
        let title = formatter.string(from: currentTime)
        
        ChatModel.shared.sendMessage(currentMessage: Message(date: currentTime, title: title, content: "\(transport) подъезжает к остановке \(stop)", time: timeString), countTime: Double(count!))
        
        withAnimation{
            success.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            withAnimation{
                isPresented = false
                dismiss()
            }
        })
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

struct ChooseTimeAlert_Previews: PreviewProvider {
    
    @State static var isPresented = true
    
    static var previews: some View {
        ChooseTimeAlert(isPresented: $isPresented, stop: "ул. Леваневского", transport: "Автобус 22", minCount: 5)
    }
}


