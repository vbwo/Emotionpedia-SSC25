import SwiftUI

/// Manages confetti and sounds celebratory effects .
class CelebrationManager: ObservableObject {
    
    @Published var showConfetti = false

    /// Triggers a celebration with sound and confetti animation.
    func triggerCelebration() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            SoundPlayer.playSuccessSound()
            self.showConfetti = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeOut(duration: 2)) {
                self.showConfetti = false
            }
        }
    }

    /// Resets the celebration state.
    func reset() {
        self.showConfetti = false
    }
}
