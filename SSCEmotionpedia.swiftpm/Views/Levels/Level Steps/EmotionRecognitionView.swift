import SwiftUI

/// Second step of the level cycle: Uses ARView to track the user's facial features and displays the recognized emotion.
struct EmotionRecognitionView<Dialogue: DialogueHandler>: View {
    
    @ObservedObject var dialogue: Dialogue
    @EnvironmentObject var coordinator: ARCoordinatorManager
    @EnvironmentObject var celebrationManager: CelebrationManager
    
    @State private var emotionDetected: Bool = false
    @State private var showChecklist: Bool = false
    @Binding var isButtonAvailable: Bool

    let emotion: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 40) {
                    ChecklistComponent(faceTracking: coordinator.faceTracking, emotion: emotion, showChecklist: $showChecklist)

                    ZStack {
                        ARViewComponent()
                        
                        if !showChecklist {
                            Color.white.opacity(0.8)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: geometry.size.width * 0.58, height: 480)
                }
                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.39)

                CelebrationComponent()
            }
            .background(.clear)
            .onAppear {
                setupView()
            }
            .onChange(of: coordinator.faceTracking.currentEmotion) { 
                DispatchQueue.main.async {
                    handleEmotionChange()
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }

    /// Resets the view state when it appears.
    private func setupView() {
        celebrationManager.reset()
        emotionDetected = false
        coordinator.resetTracking()
    }

    /// Handles changes in the detected emotion and updates the UI accordingly.
    private func handleEmotionChange() {
        guard coordinator.faceTracking.currentEmotion == emotion, !emotionDetected else { return }
        
        emotionDetected = true
        celebrationManager.triggerCelebration()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dialogue.currentDialogue = "Wow, your expression was so great!\nTap \"Next\" and move to the final step."
            dialogue.currentBrainImage = "celebrationBrainV1"
            isButtonAvailable = true
        }
    }
}
