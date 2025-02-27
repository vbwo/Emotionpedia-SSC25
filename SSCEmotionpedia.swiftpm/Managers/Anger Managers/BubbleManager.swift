import SwiftUI

/// Manages the animation and lifecycle of bubbles in the angry level.
class BubbleManager: ObservableObject {
    
    @Published var bubbles: [Bubble] = []

    func addBubble(count: Int = 8, delay: TimeInterval = 0.1) {
        for i in 0..<count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (delay * Double(i))) {
                let startX: CGFloat = UIScreen.main.bounds.width / 2
                let startY: CGFloat = UIScreen.main.bounds.height - 340
                let endX = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                let endY = CGFloat.random(in: 0...(UIScreen.main.bounds.height / 1.5))
                let startScale = CGFloat.random(in: 1.2...1.5)

                let newBubble = Bubble(x: startX, y: startY, endX: endX, endY: endY, scale: startScale)
                self.bubbles.append(newBubble)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let index = self.bubbles.firstIndex(where: { $0.id == newBubble.id }) {
                        self.bubbles[index].x = endX
                        self.bubbles[index].y = endY
                        withAnimation(.easeOut(duration: 3.0)) {
                            self.bubbles[index].scale = 0.5
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.bubbles.removeAll { $0.id == newBubble.id }
                    }
                }
            }
        }
    }
}
