import SwiftUI

/// Represents the steps in the `Happy` level, ending with the final prize.
enum HappyStages: Hashable {
    case happySituation, happyRecognition, happyActivity, happyPrize
}

/// Combines all stages of the `Happy`  level in one view.
struct HappyLevelView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var coordinator: ARCoordinatorManager
    @EnvironmentObject var narrativeManager: NarrativeManager
    @StateObject private var dialogue: HappyDialogueManager
   
    @State private var currentStage: HappyStages = .happySituation
    @State private var isGameRunning = false
    @State private var isButtonAvailable = false
    @State private var isGameFinished = false
   
    var onFinish: () -> Void
    
    init(onFinish: @escaping () -> Void, narrativeManager: NarrativeManager) {
        _dialogue = StateObject(wrappedValue: HappyDialogueManager(narrativeManager: narrativeManager))
        self.onFinish = onFinish
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                BackgroundComponent(borderColor: "orange")
                
                switch currentStage {
                case .happySituation:
                    EmotionSituationView(dialogue: dialogue, isButtonAvailable: $isButtonAvailable, emotion: .happy)
                    navigationButton(to: .happyRecognition)
                    
                case .happyRecognition:
                    EmotionRecognitionView(dialogue: dialogue, isButtonAvailable: $isButtonAvailable, emotion: "happy")
                        .onAppear { coordinator.setLevel(.happy) }
                    navigationButton(to: .happyActivity)
                    
                case .happyActivity:
                    HappyActivityView(dialogue: dialogue, isButtonAvailable: $isButtonAvailable, isGameRunning: $isGameRunning, isGameFinished: $isGameFinished, celebrationManager: CelebrationManager())
                    
                    if !isGameRunning {
                        navigationButton(to: .happyPrize)
                    }
                    
                case .happyPrize:
                    EmotionPrizeView(emotion: "happy")
                        .onAppear{ isGameFinished = false }
                    NavigationButtonComponent(
                        action: {
                            onFinish()
                            narrativeManager.stopNarration()
                        },
                        symbol: "party.popper.fill",
                        text: "Finish!",
                        circle: true
                    )
                }
                
                if !isGameRunning {
                    
                    SoundAndPauseButtonsComponent(onFinish: onFinish)
                    
                    if isGameFinished {
                        BrainFinalDialogueComponent(text: "You expressed happiness so well!\nLet's take a look on what's next?")
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
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    
    /// Advances to the next stage and updates the narration.
    /// - Parameter stage: The next stage in the `HappyStages` sequence.
    private func advanceStage(to stage: HappyStages) {
        narrativeManager.stopNarration()
        dialogue.continueDialogue()
        currentStage = stage
        isButtonAvailable = false
    }
    
    /// Creates a navigation button for transitioning between stages.
    /// - Parameter stage: The target `HappyStages` to navigate to.
    /// - Returns: A `NavigationButtonComponent` configured for stage transition.
    private func navigationButton(to stage: HappyStages) -> some View {
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
