import SwiftUI

/// Displays an interactive scenario with a dynamic background and tappable items.
struct SituationScenarioComponent<Dialogue: DialogueHandler>: View {
    
    @ObservedObject var dialogue: Dialogue
    
    @Binding var exploredItems: Set<String>
    @Binding var isButtonAvailable: Bool
    
    let backgroundFirst: String
    let backgroundSecond: String?
    let secondHeightRatio: CGFloat?
    let items: [SituationItems]
    let onItemTap: () -> Void
    let onCompletion: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SituationBackgroundComponent(
                    geometry: geometry,
                    first: backgroundFirst,
                    second: backgroundSecond,
                    secondHeightRatio: secondHeightRatio
                )
                
                ForEach(items, id: \.imageName) { item in
                    let isExplored = exploredItems.contains(item.imageName)
                    
                    SituationItemComponent(
                        imageName: item.imageName,
                        size: geometry.size.width * item.sizeMultiplier,
                        position: CGPoint(
                            x: geometry.size.width * item.position.x,
                            y: geometry.size.height * item.position.y
                        ), onTap: {
                            if !isExplored {
                                dialogue.handleItemTap(item: item.imageName)
                                exploredItems.insert(item.imageName)
                                checkButtonAvailability()
                                onItemTap()
                            }
                        }
                    )
                    .saturation(isExplored ? 0 : 1.0)
                    .overlay(
                        Group {
                            if isExplored {
                                ZStack {
                                    Circle()
                                        .foregroundStyle(Color("whiteEmotionpedia"))
                                        .scaledToFit()
                                        .frame(width: 40)
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36)
                                        .foregroundColor(.green)
                                }
                                .position(
                                    x: geometry.size.width * item.position.x,
                                    y: geometry.size.height * item.position.y
                                )
                            }
                        }
                    )
                }
                
            }
        }
        .ignoresSafeArea()
    }
    
    /// Checks if all items have been explored and enables the next step.
    private func checkButtonAvailability() {
        if exploredItems.count >= items.count {
            onCompletion()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isButtonAvailable = true
                dialogue.currentDialogue = "You did it! Every item was found! Now, let's\nmove to the next step."
                dialogue.currentBrainImage = "celebrationBrainV2"
            }
        }
    }
}


/// Defines the base properties for SituationItems.
struct SituationItems {
    let imageName: String
    let sizeMultiplier: CGFloat
    let position: CGPoint
}
