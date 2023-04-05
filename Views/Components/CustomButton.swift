import SwiftUI

struct CustomButton: View {
    let normalImage: Image
    let pressedImage: Image
    let action: () -> Void
    
    @GestureState private var isPressed: Bool = false
    
    var body: some View {
        let buttonContent = ZStack {
            if isPressed {
                pressedImage
                    .resizable()
                    .scaledToFit()
            } else {
                normalImage
                    .resizable()
                    .scaledToFit()
            }
        }
        
        return buttonContent
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
                    .onEnded { _ in
                        action()
                    }
            )
    }
}
