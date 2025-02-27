import SwiftUI

/// Represents the two phases of the breathing exercise in the Angry Activity.
enum BreathingPhase {
    case inhaling
    case blowing
}

/// Represents the pause circle that guides the user through the breathing exercise.
struct BreathingCircleComponent: View {
    @Binding var phase: BreathingPhase
    @State private var circleSize: CGFloat = 100
    @State private var text = "Inhale deeply..."
    var onComplete: (() -> Void)?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("whiteEmotionpedia"))
                    .frame(width: 500, height: 80)

                Text(text)
                    .applyFontStyle(FontStylesComponent.mainFont, color: Color("blackEmotionpedia"), size: 52)
            }
            .shadow(radius: 40)
            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.15)
           
            Image("bubble")
                .resizable()
                .scaledToFit()
                .frame(width: circleSize, height: circleSize)
                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                .shadow(radius: 20)
                .animation(.easeInOut(duration: 3), value: circleSize)
                .onAppear {
                    startInhaleAnimation()
                }
        }
    }
  
    /// Animates the inhale phase by expanding the circle over 3 seconds,  transitions to the blowing phase and triggers `onComplete()`.
    func startInhaleAnimation() {
        withAnimation(.easeInOut(duration: 3)) {
            circleSize = 250
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            phase = .blowing
            text = "Exhale slowly..."
            onComplete?()
        }
    }
}
