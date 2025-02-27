import SwiftUI

/// Displays a checklist for guiding the user to mimic facial expressions for a given emotion.
struct ChecklistComponent: View {
    @ObservedObject var faceTracking = FaceTrackingManager()
    @EnvironmentObject var coordinator: ARCoordinatorManager
    var emotion: String
    @Binding var showChecklist: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(emotion == "happy" ? Color("orangeEmotionpedia") : Color("redEmotionpedia"))
                .frame(width: 330)
            
            VStack {
                if !showChecklist {
                    InstructionsComponent(
                        description: "Tap ‘Start’ to open the checklist\nand copy the \(emotion) expression.",
                        instruction: "Be in front of the camera\nin a well-lit area.",
                        image: emotion == "happy" ? "happyRecognitionTutorial" : "angryRecognitionTutorial",
                        onStart: {
                            showChecklist = true
                            coordinator.isTrackingActive = true
                        }
                    )
                } else {
                    VStack(spacing: 40) {
                        Text("Checklist")
                            .applyFontStyle(FontStylesComponent.secondaryFont, color: Color("whiteEmotionpedia"), size: 68)
                            .padding(.bottom, 8)
                        
                        Text("The circles will be checked once you\ncorrectly imitate the face parts!")
                            .applyFontStyle(FontStylesComponent.mainFont, color: Color("whiteEmotionpedia"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .padding(.bottom, 8)
                        
                        VStack(alignment: .leading, spacing: 28) {
                            if emotion == "angry" {
                                ChecklistItemComponent(title: "Eyebrows", bodyText: "Pulled down and together.", isChecked: $faceTracking.isEyebrowChecked)
                                ChecklistItemComponent(title: "Nose", bodyText: "Sneer nose.", isChecked: $faceTracking.isNoseChecked)
                                ChecklistItemComponent(title: "Mouth", bodyText: "Tight and showing teeth.", isChecked: $faceTracking.isAngryMouthChecked)
                            }
                            
                            if emotion == "happy" {
                                ChecklistItemComponent(title: "Eyes", bodyText: "Squint eyes.", isChecked: $faceTracking.isEyeChecked)
                                ChecklistItemComponent(title: "Cheeks", bodyText: "Squint cheeks.", isChecked: $faceTracking.isCheekChecked)
                                ChecklistItemComponent(title: "Mouth", bodyText: "Big smile.", isChecked: $faceTracking.isHappyMouthChecked)
                            }
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showChecklist)
        }
        .mask(
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 330, height: 480)
        )
    }
}
