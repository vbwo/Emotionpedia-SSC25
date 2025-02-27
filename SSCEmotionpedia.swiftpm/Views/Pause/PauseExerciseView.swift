import SwiftUI

/// Displays the number counting activity for the pause exercise.
struct PauseExerciseView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var narrativeManager: NarrativeManager
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var celebrationManager: CelebrationManager
    @StateObject var speechRecognizer = NumberRecognizerManager()
    
    @State private var areButtonsAvailable: Bool = false
    @State private var recognizedNumbers: Set<Int> = []
    
    private let screenText =
        "Count from one to ten slowly,\npaying attention to your breathing."
    
    
    let arrayNumbers = Array(1...10)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 40) {
                    Text(screenText)
                        .applyFontStyle(FontStylesComponent.secondaryFont, color: Color("blueEmotionpedia"), size: 60)
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(
                        columns: Array(repeating: GridItem(), count: 5),
                        spacing: 40
                    ) {
                        ForEach(arrayNumbers, id: \.self) { number in
                            ZStack {
                                Image("greenCircle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120)
                                
                                Text("\(number)")
                                    .applyFontStyle(FontStylesComponent.tertiaryFont, size: 80)
                            }
                            .frame(width: 160, height: 160)
                            .saturation(recognizedNumbers.contains(number) ? 1 : 0)
                        }
                    }
                    .frame(width: geometry.size.width * 0.7)
                    .animation(.easeInOut(duration: 0.5), value: recognizedNumbers)
                    
                    if areButtonsAvailable {
                        HStack(spacing: 40) {
                            RegularButtonComponent(
                                action: {
                                    resetExercise()
                                },
                                color: Color("blueEmotionpedia"),
                                text: "Repeat",
                                width: 192,
                                height: 52
                            )
                            
                            RegularButtonComponent(
                                action: {
                                    dismiss()
                                },
                                color: Color("yellowEmotionpedia"),
                                text: "Resume",
                                width: 192,
                                height: 52
                            )
                        }
                        .padding(.bottom, 50)
                    }
                }
                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                
                CelebrationComponent()
            }
            .background(.clear)
            .onAppear {
                setupExercise()
                narrativeManager.narrate(text: screenText)
            }
            .onChange(of: speechRecognizer.recognizedNumber) {
                handleRecognition(speechRecognizer.recognizedNumber)
            }
            .onDisappear(perform: cleanUpExercise)
        }
    }
    
    /// Handles the setup of the exercise on appearance.
    private func setupExercise() {
        celebrationManager.reset()
        speechRecognizer.startRecognition()
    }
    
    /// Handles speech recognition changes.
    /// - Parameter newValue: The latest recognized number from speech input.
    private func handleRecognition(_ newValue: Int) {
        guard arrayNumbers.contains(newValue), !recognizedNumbers.contains(newValue) else { return }
        
        DispatchQueue.main.async {
            recognizedNumbers.insert(newValue)
            
            if recognizedNumbers.count == arrayNumbers.count {
                withAnimation {
                    celebrationManager.triggerCelebration()
                    areButtonsAvailable = true
                }
            }
        }
    }

    
    /// Cleans up when the view disappears.
    private func cleanUpExercise() {
        celebrationManager.reset()
        speechRecognizer.stopRecognition()
    }
    
    /// Resets the exercise state.
    private func resetExercise() {
        recognizedNumbers.removeAll()
        areButtonsAvailable = false
        celebrationManager.reset()
        speechRecognizer.resetRecognition()
    }
}
