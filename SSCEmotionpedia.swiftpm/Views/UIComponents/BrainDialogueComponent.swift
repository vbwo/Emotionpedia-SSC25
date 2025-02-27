import SwiftUI

/// Displays the brain's dialogue based on the current emotion.
struct BrainDialogueComponent<DialogueType: ObservableObject>: View {
    @ObservedObject var dialogue: DialogueType
    var brain: String
    var emotion: String
    var continueAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                ZStack {
                    HStack(spacing: 32) {
                        Image(emotion)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 214, alignment: .leading)
                        
                        ZStack {
                            Image("balloon2")
                                .resizable()
                                .frame(width: 650, height: 150)
                            
                            if let angryDialogue = dialogue as? AngryDialogueManager {
                                Text(angryDialogue.currentDialogue)
                                    .applyFontStyle(FontStylesComponent.mainFont, size: 36)
                                    .lineSpacing(16)
                            } else if let happyDialogue = dialogue as? HappyDialogueManager {
                                Text(happyDialogue.currentDialogue)
                                    .applyFontStyle(FontStylesComponent.mainFont, size: 36)
                                    .lineSpacing(16)
                            }
                        }
                        .padding(.bottom, -50)
                        
                        Spacer()
                    }
                    .frame(width: 1000)
                }
            }
        }
        .frame(height: 710)
        .ignoresSafeArea()
    }
    
}
