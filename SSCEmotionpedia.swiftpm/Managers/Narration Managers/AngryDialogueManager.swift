import Combine

/// Manages the angry level dialogue flow and user interactions.
class AngryDialogueManager: ObservableObject, DialogueHandler {
    
    @Published var currentDialogue: String {
        didSet {
            narrativeManager.narrateDialogue(currentDialogue, delay: 0)
        }
    }
    @Published var currentBrainImage: String
    @Published var isFirstDialogueActive: Bool
    @Published var isSecondDialogueActive: Bool

    private var narrativeManager: NarrativeManager
    private var brainImages = ["angrySituBrain1", "angrySituBrain2", "angrySituBrain3"]
    private var brainImageIndex = 0

    private let defaultDialogue = "Anger happens when something bothers us. Tap\nthe items to see what can make us angry!"

    init(narrativeManager: NarrativeManager) {
        self.narrativeManager = narrativeManager
        self.currentDialogue = defaultDialogue
        self.currentBrainImage = brainImages[0]
        self.isFirstDialogueActive = true
        self.isSecondDialogueActive = true
        narrativeManager.narrateDialogue(currentDialogue, delay: 0)
    }

    /// Handles item taps by updating the dialogue and brain image.
    /// - Parameter item: The tapped item in the scene.
    func handleItemTap(item: String) {
        switch item {
        case "sofa":
            currentDialogue = "Oh no, the pillow is out of place!"
        case "soundbox":
            currentDialogue = "This music is so loud!"
        case "lamp":
            currentDialogue = "This lamp is too bright!"
        case "messandkid":
            currentDialogue = "Spilled popcorn and broken toys!"
        case "television":
            currentDialogue = "The TV is off, and I lost the remote!"
        default:
            resetDialogue()
        }

        brainImageIndex = (brainImageIndex + 1) % brainImages.count
        currentBrainImage = brainImages[brainImageIndex]
        
        narrativeManager.stopNarration()
    }
    
    /// Advances the dialogue to the next stage.
    func continueDialogue() {
        if isFirstDialogueActive {
            isFirstDialogueActive = false
            currentDialogue = "Now, let's make our angriest faces for the\ncamera after you press start!"
            currentBrainImage = "angryRecBrain"
        } else if isSecondDialogueActive {
            isSecondDialogueActive = false
            currentDialogue = "Breathing deeply can help us to calm down!\nPress start to make bubbles until the\nAnger Level bar is empty."
            currentBrainImage = "angrySituBrain1"
        } else {
            currentDialogue = "Thanks for teaching me how to recognize\nand express anger! Save your prize to\nrevisit anytime!"
            currentBrainImage = "celebrationBrainV2"
        }
    }
    
    /// Resets the dialogue and brain image to their initial states.
    func resetDialogue() {
        currentDialogue = defaultDialogue
        currentBrainImage = brainImages[0]
    }
}
