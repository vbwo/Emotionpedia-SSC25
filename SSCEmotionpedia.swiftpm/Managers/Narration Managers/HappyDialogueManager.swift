import Combine

/// Manages the happy level dialogue flow and user interactions.
class HappyDialogueManager: ObservableObject, DialogueHandler {
    
    @Published var currentDialogue: String {
        didSet {
            narrativeManager.narrateDialogue(currentDialogue, delay: 0)
        }
    }
    @Published var currentBrainImage: String
    @Published var isFirstDialogueActive: Bool
    @Published var isSecondDialogueActive: Bool
    
    private var narrativeManager: NarrativeManager
    private var brainImages = ["happySituBrain1", "happySituBrain2", "happySituBrain3"]
    private var brainImageIndex = 0
    
    private let defaultDialogue = "Happiness happens when things go well! Tap\nthe items to see what can make us happy!"
    
    init(narrativeManager: NarrativeManager) {
        self.narrativeManager = narrativeManager
        self.currentDialogue = defaultDialogue
        self.currentBrainImage = brainImages[0]
        self.isFirstDialogueActive = true
        self.isSecondDialogueActive = true
        narrativeManager.narrateDialogue(currentDialogue, delay: 0)
    }
    
    /// Updates the dialogue and mascot image when an item is tapped.
    /// - Parameter item: The tapped interactive item.
    func handleItemTap(item: String) {
        switch item {
        case "balloons":
            currentDialogue = "These colorful balloons make the party so fun!"
        case "table":
            currentDialogue = "Cake, juice, gifts—I can’t wait to enjoy them!"
        case "kids":
            currentDialogue = "That girl had fun on her iPad—maybe creating something cool! Now she’s ready to party!"
        case "cat":
            currentDialogue = "That fluffy orange cat looks so cute!"
        case "sun":
            currentDialogue = "The warm sun makes the party even more special!"
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
            currentDialogue = "Now, let's make our happiest faces for the\ncamera after you press start!"
            currentBrainImage = "happySituBrain1"
        } else if isSecondDialogueActive {
            isSecondDialogueActive = false
            currentDialogue = "Clapping is a great way to show happiness!\nFollow the instructions above and press start!"
            currentBrainImage = "happySituBrain2"
        } else {
            currentDialogue = "Thanks for teaching me how to recognize\nand express happiness! Save your prize\nto revisit anytime!"
            currentBrainImage = "celebrationBrainV2"
        }
    }
    
    /// Resets the dialogue and mascot image to their initial states.
    func resetDialogue() {
        currentDialogue = defaultDialogue
        currentBrainImage = brainImages[0]
    }
}
