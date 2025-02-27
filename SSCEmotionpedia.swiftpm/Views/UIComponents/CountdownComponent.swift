import SwiftUI

/// Displays a countdown timer before the activity games start.
struct CountdownComponent: View {
    let emotion: String
    let countdown: Int
    let updateCountdown: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(emotion == "happy" ? Color("orangeEmotionpedia") : Color("redEmotionpedia"))
                .scaledToFit()
                .frame(width: 100)
            Text("\(countdown)")
                .applyFontStyle(FontStylesComponent.tertiaryFont, color: Color("whiteEmotionpedia"), size: 80)
                .padding(.top, 4)
                .transition(.scale)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        updateCountdown()
                    }
                }
        }
    }
    
}
