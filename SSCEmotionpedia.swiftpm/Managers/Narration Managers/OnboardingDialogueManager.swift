import SwiftUI

/// Manages the onboarding dialogue flow with the mascot.
class OnboardingDialogueManager: ObservableObject {
    
    @Published var brainDialogue = 0
    private var narrativeManager: NarrativeManager
    
    init(narrativeManager: NarrativeManager) {
        self.narrativeManager = narrativeManager
        narrativeManager.narrateDialogue(getBrainDialogueText().dialogue, delay: 0)
    }
    
    /// Represents a step in the mascot's dialogue, including text, brain image, button text, and background color.
    struct DialogueData {
        let dialogue: String
        let brain: String
        let button: String
        let color: Color
    }
    
    /// Returns the dialogue data for the current step.
    func getBrainDialogueText() -> DialogueData {
        switch brainDialogue {
        case 0:
            return DialogueData(dialogue: "Hi! I'm your Brain and\nI live inside your head!",
                                brain: "happyBrain",
                                button: "Continue",
                                color: Color("yellowEmotionpedia"))
        case 1:
            return DialogueData(dialogue: "I help you understand\nand manage your feelings.",
                                brain: "surprisedBrainPointing",
                                button: "Continue",
                                color: Color("yellowEmotionpedia"))
        case 2:
            return DialogueData(dialogue: "But to do this, we need to\nexplore more about\nemotions!",
                                brain: "neutralBrainPointing",
                                button: "Let's get started!",
                                color: Color("greenEmotionpedia"))
        default:
            return getBrainDialogueText()
        }
    }
    
    /// Advances the dialogue to the next step.
    func continueDialogue() {
        if brainDialogue < 2 {
            brainDialogue += 1
            narrativeManager.narrateDialogue(getBrainDialogueText().dialogue)
        }
    }
}
