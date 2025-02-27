import SwiftUI

/// Displays the brain's final dialogue at activities/game end.
struct BrainFinalDialogueComponent: View {
    @EnvironmentObject var narrativeManager: NarrativeManager
    var text: String
    
    var body: some View {
        
        VStack(spacing: -80) {
            Image("celebrationBrainV2")
                .resizable()
                .scaledToFit()
                .frame(width: 280)
                .offset(x: -8)
            
            ZStack {
                Image("balloon2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 550)
                
                Text(text)
                    .applyFontStyle(FontStylesComponent.mainFont, size: 36)
                    .multilineTextAlignment(.center)
                    .frame(width: 500)
                    .lineSpacing(16)
            }
        } .onAppear {
            narrativeManager.narrate(text: text)
        }
    }
}
