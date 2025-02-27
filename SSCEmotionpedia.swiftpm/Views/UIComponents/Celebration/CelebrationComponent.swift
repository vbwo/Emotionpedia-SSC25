import SwiftUI

/// Displays a confetti animation when triggered by the `CelebrationManager`.
struct CelebrationComponent: View {
    @EnvironmentObject var celebrationManager: CelebrationManager

    var body: some View {
        ZStack {
            if celebrationManager.showConfetti {
                ConfettiContainerComponent()
                    .zIndex(2)
            }
        }
    }
}
