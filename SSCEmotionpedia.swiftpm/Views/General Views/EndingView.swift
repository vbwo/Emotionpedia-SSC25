import SwiftUI

/// Displays the ending screen with a congratulatory message and option to view credits.
struct EndingView: View {
    
    @EnvironmentObject private var narrativeManager: NarrativeManager
    @EnvironmentObject private var navigationManager: NavigationManager
    
    private let screenText = [
        "Fantastic!",
        "You successfully expressed different emotions.",
        "Understanding feelings is awesome!\nI am sure you and I will keep working\nto explore more emotions."
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundComponent(borderColor: "blue")
                
                VStack {
                    Text(screenText[0])
                        .applyFontStyle(FontStylesComponent.secondaryFont, color: Color("blueEmotionpedia"), size: 120)
                    Text(screenText[1])
                        .applyFontStyle(FontStylesComponent.mainFont, size: 52)
                   
              
                    BrainFinalDialogueComponent(text: screenText[2])
                    
                    Spacer()
                    
                    HStack(spacing: 60) {
                        RegularButtonComponent(
                            action: {
                                narrativeManager.stopNarration()
                                navigationManager.path.append("CreditsView")
                            },
                            color: Color("blueEmotionpedia"),
                            text: "Credits",
                            width: 220,
                            height: 56
                        )
                    }
                
                    
                }
                .frame(height: geometry.size.height * 0.83)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .onAppear {
                narrativeManager.narrate(text: screenText.joined(separator: " "))
            }
        }
    }
}
