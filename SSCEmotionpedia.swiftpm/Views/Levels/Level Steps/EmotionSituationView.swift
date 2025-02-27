import SwiftUI

/// Represents the emotions to be explored.
enum Emotion {
    case happy, angry
}

/// First step of the level: Displays a scene related to the chosen emotion.
struct EmotionSituationView<Dialogue: DialogueHandler>: View {
    
    @EnvironmentObject var celebrationManager: CelebrationManager
    @StateObject var dialogue: Dialogue
    
    @State private var exploredItems: Set<String> = []
    @State private var isAnimating: Bool = false
    @Binding var isButtonAvailable: Bool
    
    let emotion: Emotion

    /// Returns the corresponding assets and values for each emotion.
    private var sceneConfig: (backgroundFirst: String, backgroundSecond: String?, secondHeightRatio: CGFloat?, items: [SituationItems]) {
        switch emotion {
        case .happy:
            return (
                "sky",
                "grass",
                0.6,
                [
                    SituationItems(imageName: "sun", sizeMultiplier: 0.3, position: CGPoint(x: 0.5, y: 0.2)),
                    SituationItems(imageName: "balloons", sizeMultiplier: 0.17, position: CGPoint(x: 0.2, y: 0.73)),
                    SituationItems(imageName: "table", sizeMultiplier: 0.4, position: CGPoint(x: 0.5, y: 0.65)),
                    SituationItems(imageName: "kids", sizeMultiplier: 0.25, position: CGPoint(x: 0.82, y: 0.72)),
                    SituationItems(imageName: "cat", sizeMultiplier: 0.07, position: CGPoint(x: 0.5, y: 0.8))
                ]
            )
        case .angry:
            return (
                "livingroombackground",
                nil,
                nil,
                [
                    SituationItems(imageName: "sofa", sizeMultiplier: 0.38, position: CGPoint(x: 0.25, y: 0.6)),
                    SituationItems(imageName: "soundbox", sizeMultiplier: 0.12, position: CGPoint(x: 0.75, y: 0.58)),
                    SituationItems(imageName: "lamp", sizeMultiplier: 0.27, position: CGPoint(x: 0.53, y: 0.48)),
                    SituationItems(imageName: "messandkid", sizeMultiplier: 0.53, position: CGPoint(x: 0.47, y: 0.71)),
                    SituationItems(imageName: "television", sizeMultiplier: 0.26, position: CGPoint(x: 0.89, y: 0.65))
                ]
            )
        }
    }

    var body: some View {
        ZStack {
            SituationScenarioComponent(
                dialogue: dialogue,
                exploredItems: $exploredItems,
                isButtonAvailable: $isButtonAvailable,
                backgroundFirst: sceneConfig.backgroundFirst,
                backgroundSecond: sceneConfig.backgroundSecond,
                secondHeightRatio: sceneConfig.secondHeightRatio,
                items: sceneConfig.items,
                onItemTap: triggerAnimation,
                onCompletion: { celebrationManager.triggerCelebration() }
            )
            .mask(
                Image("situationMask")
                    .resizable()
                    .frame(width: 1030, height: 460)
            )
            .overlay(itemsCounter)
            .padding(.bottom, 160)

            CelebrationComponent()
        }
        .background(.clear)
        .ignoresSafeArea()
        .onAppear(perform: setupScene)
    }

    /// Displays the counter for explored items.
    private var itemsCounter: some View {
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(emotion == .happy ? Color("orangeEmotionpedia") : Color("redEmotionpedia"))
                        .shadow(radius: 8)
                        .frame(width: 160, height: 56)
                    
                    HStack {
                        Text("Items:")
                            .applyFontStyle(FontStylesComponent.secondaryFont, color: Color("whiteEmotionpedia"), size: 36)
                        
                        Text("\(exploredItems.count)/\(sceneConfig.items.count)")
                            .applyFontStyle(FontStylesComponent.tertiaryFont, size: 36)
                            .offset(y: 4)
                    }
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.easeOut(duration: 0.2), value: isAnimating)
                }
                Spacer()
            }
            .frame(width: 980)
            Spacer()
        }
        .frame(height: 412)
    }

    /// Triggers a small animation when an item is tapped.
    private func triggerAnimation() {
        withAnimation(.easeOut(duration: 0.2)) {
            isAnimating = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isAnimating = false
        }
    }

    /// Resets celebration status when the view appears.
    private func setupScene() {
        celebrationManager.reset()
    }
}
