import SwiftUI

struct CustomAlertButton: View {

    // MARK: - Value
    // MARK: Public
    let title: LocalizedStringKey
    var action: (() -> Void)? = nil
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        Button {
          action?()
        
        } label: {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
        }
        .padding(15)
        .background(Color.orange)
        .cornerRadius(15)
    }
}
