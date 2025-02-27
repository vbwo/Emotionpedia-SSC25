import SwiftUI

/// Defines the available game levels.
enum Level: Hashable {
    case happy
    case angry
}

/// Displays the level selection screen for the game.
struct LevelsView: View {
    
    @EnvironmentObject private var narrativeManager: NarrativeManager
    @EnvironmentObject private var navigationManager: NavigationManager
    
    private let screenText = [
        "Let's learn about happiness and anger!",
        "Tap on which you want to learn now."
    ]
    
    var body: some View {
        ZStack {
            BackgroundComponent(borderColor: "blue")
            
            VStack {
                Spacer()
                
                Text(screenText[0])
                    .applyFontStyle(FontStylesComponent.secondaryFont, color: Color("blueEmotionpedia"), size: 64)
                
                Text(screenText[1])
                    .applyFontStyle(FontStylesComponent.mainFont, size: 52)
                
                Spacer()
                
                HStack(spacing: 150) {
                    levelSelectionButton(for: .happy, imageName: "happyFaceBlue", completedImage: "happyFaceGreen")
                    levelSelectionButton(for: .angry, imageName: "angryFaceBlue", completedImage: "angryFaceGreen")
                }
                
                Spacer()
            
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .onAppear {
            narrativeManager.narrate(text: screenText.joined(separator: " "))
        }
    }
    
    /// Creates a button to select a level.
    /// - Parameters:
    ///   - level: The level being displayed.
    ///   - imageName: The default image for the level.
    ///   - completedImage: The image displayed if the level is completed.
    private func levelSelectionButton(for level: Level, imageName: String, completedImage: String) -> some View {
        if navigationManager.completedLevels.contains(level) {
            return AnyView(
                VStack(spacing: 8) {
                    LevelImagesComponent(imageName: completedImage, imageSize: 250, levelName: levelText(for: level))
                    Text("Completed! ✅")
                        .applyFontStyle(FontStylesComponent.mainFont, size: 24)
                }
            )
        } else {
            return AnyView(
                NavigationLink(value: level) {
                    LevelImagesComponent(imageName: imageName, imageSize: 250, levelName: levelText(for: level))
                }
                .simultaneousGesture(TapGesture().onEnded {
                    narrativeManager.stopNarration()
                })
            )
        }
    }
    
    /// Returns the text label for a given level.
    /// - Parameter level: The game level for which the label is needed.
    /// - Returns: A `String` representing the level name.
    private func levelText(for level: Level) -> String {
        switch level {
        case .happy: return "Happy"
        case .angry: return "Angry"
        }
    }
}
