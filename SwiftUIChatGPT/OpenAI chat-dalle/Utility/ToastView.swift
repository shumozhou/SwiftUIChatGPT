import SwiftUI

struct ToastView<Content: View>: View {
    @Binding var isShowing: Bool
    let duration: TimeInterval
    let content: () -> Content
    
    var body: some View {
        Group {
            if isShowing {
                content()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: duration))
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            isShowing = false
                        }
                    })
            }
        }
    }
}
