import SwiftUI

enum EmotionLevel: Hashable {
    case happy
    case angry
}

enum EmotionStages: Hashable {
    case situation
    case recognition
    case activity
}

struct EmotionLevelView: View {
    @EnvironmentObject var speechViewModel: NarrativeSpeech
       var emotion: EmotionLevel
       @State private var currentStage: EmotionStages = .situation

    var body: some View {
        ZStack {
            let borderColor = emotion == .happy ? "orange" : "red"
            Background(borderColor: borderColor)
            
            switch currentStage {
            case .situation:
                EmotionSituation(emotion: emotion, dialogue: getDialogue())
                NextButton {
                    currentStage = .recognition
                }
            case .recognition:
                EmotionRecognition(emotion: getEmotionString())
                NextButton {
                    currentStage = .activity
                }
            case .activity:
                getActivityView()
                BrainDialogue(dialogue: getDialogue(),
                              brain: getDialogue().currentBrainImage,
                              emotion: getEmotionString(),
                              buttonText: getDialogue().currentButtonText,
                              continueAction: getDialogue().continueDialogue)
            }
            
            SoundAndPauseButtons()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    
    private func getDialogue() -> some DialogueHandler {
        switch emotion {
        case .happy:
            return HappyDialogue()
        case .angry:
            return AngryDialogue()
        }
    }
    
    private func getEmotionString() -> String {
        switch emotion {
        case .happy:
            return "happy"
        case .angry:
            return "angry"
        }
    }
    
    private func getActivityView() -> some View {
        switch emotion {
        case .happy:
            return AnyView(HappyActivity())
        case .angry:
            return AnyView(AngryActivity())
        }
    }
}
