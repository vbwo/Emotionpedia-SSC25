import SwiftUI

/// Represents the screens to be shown in PauseView.
enum PauseStep {
    case instruction
    case exercise
}

/// Manages the pause flow, switching between instructions and the counting exercise.
struct PauseView: View {
    
    @EnvironmentObject var narrativeManager: NarrativeManager
    @State private var currentStep: PauseStep = .instruction
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundComponent(borderColor: "blue")
                
                switch currentStep {
                case .instruction:
                    PauseInstructionsView(currentStep: $currentStep)
                case .exercise:
                    PauseExerciseView()
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}
