import SwiftUI

/// Displays dialogue and an interactive button to progress through onboarding steps.
struct OnboardingView: View {
    
    @EnvironmentObject var narrativeManager: NarrativeManager
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject private var dialogueManager: OnboardingDialogueManager
    
    init(narrativeManager: NarrativeManager) {
        _dialogueManager = StateObject(wrappedValue: OnboardingDialogueManager(narrativeManager: narrativeManager))
    }
    
    var body: some View {
        ZStack {
            HStack {
                Image(dialogueManager.getBrainDialogueText().brain)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 370)
                
                VStack(alignment: .trailing, spacing: 20) {
                    ZStack {
                        Image("balloon")
                            .resizable()
                            .scaledToFit()
                        Text(dialogueManager.getBrainDialogueText().dialogue)
                            .applyFontStyle(FontStylesComponent.mainFont, size: 36)
                            .lineSpacing(16)
                    }
                    
                    RegularButtonComponent(
                        action: {
                            narrativeManager.stopNarration()
                            if dialogueManager.brainDialogue == 2 {
                                navigationManager.path.append("LevelsView")
                            } else {
                                dialogueManager.continueDialogue()
                            }
                        },
                        color: dialogueManager.getBrainDialogueText().color,
                        text: dialogueManager.getBrainDialogueText().button,
                        width: 230,
                        height: 56
                    )
                }
                .padding(.bottom, 300)
            }
            .frame(width: 800)
            .padding(.top, 160)
        }
        .background(.clear)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}
