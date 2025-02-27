import SwiftUI

/// Represents an interactive item in the EmotionSituation scenario, allowing user interaction.
struct SituationItemComponent: View {
   
    @State var glow = false
    
    let imageName: String
    let size: CGFloat
    let position: CGPoint
    let onTap: () -> Void
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .position(position)
            .onTapGesture {
                onTap()
            }
            .shadow(color: Color.black.opacity(glow ? 0.3 : 0), radius: 16)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    glow.toggle()
                }
            }
    }
}
