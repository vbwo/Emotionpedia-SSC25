import SwiftUI

/// Displays an instructions screen before starting an activity.
struct InstructionsComponent: View {
    var description: String
    var instruction: String
    var image: String
    var onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Text("Instructions")
                .applyFontStyle(FontStylesComponent.secondaryFont, color: Color("whiteEmotionpedia"), size: 60)
            
            Text(description)
                .applyFontStyle(FontStylesComponent.mainFont, color: Color("whiteEmotionpedia"))
                .multilineTextAlignment(.center)
                .lineSpacing(8)
            
            Rectangle()
                .frame(width: 250, height: 0.5)
                .foregroundStyle(Color("whiteEmotionpedia"))
            
            Spacer()
            
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            
            Text(instruction)
                .applyFontStyle(FontStylesComponent.mainFont, color: Color("whiteEmotionpedia"))
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 32)
            
            RegularButtonComponent(
                action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        onStart()
                    }
                },
                color: Color("yellowEmotionpedia"),
                text: "Start!",
                width: 280,
                height: 40
            )
            .padding(.top, 20)
            
            Spacer()
        }
        .frame(height: 480)
        .transition(.move(edge: .leading))
    }
}
