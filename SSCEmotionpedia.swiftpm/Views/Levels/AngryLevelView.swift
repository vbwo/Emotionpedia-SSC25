import SwiftUI

/// Represents the steps in the `Angry` level, ending with the final prize.
enum AngryStages: Hashable {
    case angrySituation, angryRecognition, angryActivity, angryPrize
}

/// Combines all stages of the `Angry` level in one view.
struct AngryLevelView: View {
    
    @EnvironmentObject var coordinator: ARCoordinatorManager
    @EnvironmentObject var narrativeManager: NarrativeManager
    @StateObject private var dialogue: AngryDialogueManager
   
    @State private var currentStage: AngryStages = .angrySituation
    @State private var isButtonAvailable = false
    @State private var isGameRunning = false
    @State private var isGameFinished = false
    
    var onFinish: () -> Void
    
    private let screenText = "You did a great job regulating anger!\nLet's take a look on what's next?"
        
    
    
    init(onFinish: @escaping () -> Void, narrativeManager: NarrativeManager) {
        _dialogue = StateObject(wrappedValue: AngryDialogueManager(narrativeManager: narrativeManager))
        self.onFinish = onFinish
    }
    
    var body: some View {
        ZStack {
            BackgroundComponent(borderColor: "red")
            
            switch currentStage {
            case .angrySituation:
                EmotionSituationView(dialogue: dialogue, isButtonAvailable: $isButtonAvailable, emotion: .angry)
                navigationButton(to: .angryRecognition)

            case .angryRecognition:
                EmotionRecognitionView(dialogue: dialogue, isButtonAvailable: $isButtonAvailable, emotion: "angry")
                    .onAppear { coordinator.setLevel(.angry) }
                navigationButton(to: .angryActivity)

            case .angryActivity:
                AngryActivityView(dialogue: dialogue, isGameRunning: $isGameRunning, isButtonAvailable: $isButtonAvailable, isGameFinished: $isGameFinished, emotion: .angry)
                
                if !isGameRunning {
                    navigationButton(to: .angryPrize)
                }
                
            case .angryPrize:
                EmotionPrizeView(emotion: "angry")
                    .onAppear{ isGameFinished = false }
                NavigationButtonComponent(
                    action: { onFinish() },
                    symbol: "party.popper.fill",
                    text: "Finish!",
                    circle: true
                )
            }
            
            
            if !isGameRunning {
                
                SoundAndPauseButtonsComponent(onFinish: onFinish)
                
                if isGameFinished {
                    BrainFinalDialogueComponent(text: screenText)
                } else {
                    BrainDialogueComponent(
                        dialogue: dialogue,
                        brain: dialogue.currentBrainImage,
                        emotion: dialogue.currentBrainImage,
                        continueAction: { dialogue.continueDialogue() }
                    )
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    
    /// Advances to the next stage and updates the narration.
    /// - Parameter stage: The next stage in the `AngryStages` sequence.
    private func advanceStage(to stage: AngryStages) {
        narrativeManager.stopNarration()
        dialogue.continueDialogue()
        currentStage = stage
        isButtonAvailable = false
    }

    /// Creates a navigation button for transitioning between stages.
    /// - Parameter stage: The target `AngryStages` to navigate to.
    /// - Returns: A `NavigationButtonComponent` configured for stage transition.
    private func navigationButton(to stage: AngryStages) -> some View {
        NavigationButtonComponent(
            action: {
                if isButtonAvailable {
                    advanceStage(to: stage)
                }
            },
            symbol: "arrowshape.forward.circle.fill",
            text: "Next",
            circle: false
        )
        .disabled(!isButtonAvailable)
        .saturation(isButtonAvailable ? 1 : 0)
    }
}
