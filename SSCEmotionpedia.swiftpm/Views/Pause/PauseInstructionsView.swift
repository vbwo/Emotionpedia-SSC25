import SwiftUI

/// Presents instructions for the pause activity (counting from 1 to 10).
struct PauseInstructionsView: View {
    
    @EnvironmentObject private var narrativeManager: NarrativeManager
    @Binding var currentStep: PauseStep
    
    private let screenText = [
        "Let's take a break\nand count from one to ten!",
        "Did you know that when we count slowly, our brain\nslows down and we feel more relaxed?\n\n\nTap 'Start' and count out loud.\nThe numbers will turn green as you say them!"
    ]
    
    var body: some View {
        VStack(spacing: 152) {
            VStack(spacing: 24) {
                Text(screenText[0])
                    .applyFontStyle(FontStylesComponent.secondaryFont, color: Color("blueEmotionpedia"), size: 80)
                    .multilineTextAlignment(.center)
                
                Text(screenText[1])
                    .applyFontStyle(FontStylesComponent.mainFont, size: 40)
                    .multilineTextAlignment(.center)
            }
            
            RegularButtonComponent(
                action: {
                    currentStep = .exercise
                },
                color: Color("yellowEmotionpedia"),
                text: "Start!",
                width: 192,
                height: 52
            )
        }  .onAppear {
            narrativeManager.narrate(text: screenText.joined(separator: " "))
        }
    }
}
