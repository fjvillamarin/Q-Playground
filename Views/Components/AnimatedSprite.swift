import SwiftUI

struct AnimatedSprite: View {
    @State private var frameIndex: Int = 1
    let frameCount: Int = 19
    let imagePrefix: String = "fox"
    let animationDuration: TimeInterval = 0.15
    
    var body: some View {
        Image("\(imagePrefix)_\(frameIndex)")
            .resizable()
            .scaledToFit()
            .onAppear {
                startAnimation()
            }
    }
    
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
            frameIndex = (frameIndex % frameCount) + 1
        }
    }
}
