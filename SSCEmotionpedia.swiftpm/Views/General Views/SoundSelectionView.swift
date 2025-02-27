import SwiftUI

/// Lets the user choose whether to play with sound or not.
struct SoundScreen: View {
    
    @EnvironmentObject var speechViewModel: NarrativeManager
    
    @State private var showOnboarding = false
    @State private var showTransitionScreen = false
    @State private var selectedSoundOption: SoundOption = .none
    @State private var isButtonPressed = false
    
    var body: some View {
        ZStack {
            VStack {
                if !showOnboarding && !showTransitionScreen {
                    Text("Would you like to play with or without sound?\nYou can change your choice later.")
                        .applyFontStyle(FontStylesComponent.mainFont, size: 60)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 100) {
                        SoundButtonComponent(
                            imageName: "greenCircle",
                            selectedSoundOption: .sound,
                            action: enableSound,
                            fontStyle: FontStylesComponent.mainFont,
                            size: 36,
                            spacing: 16,
                            iconHeight: 70,
                            isUnderlined: selectedSoundOption == .sound
                        )

                        SoundButtonComponent(
                            imageName: "redCircle",
                            selectedSoundOption: .noSound,
                            action: disableSound,
                            fontStyle: FontStylesComponent.mainFont,
                            size: 36,
                            spacing: 16,
                            iconHeight: 85,
                            isUnderlined: selectedSoundOption == .noSound
                        )
                    }
                    .frame(height: 200)
                    .padding(.top, 40)

                    if selectedSoundOption != .none {
                        Button(action: startTransition) {
                            Text("Tap here to continue")
                                .applyFontStyle(FontStylesComponent.mainFont, size: 60)
                                .padding(.top, 40)
                        }
                        .offset(y: isButtonPressed ? 40 : 0)
                        .animation(.easeInOut(duration: 0.5), value: isButtonPressed)
                    }
                }
            }
            .opacity(showOnboarding ? 0 : 1)
            .animation(.easeInOut(duration: 1.0), value: showOnboarding)
            
            if showTransitionScreen {
                BackgroundComponent(borderColor: "blue")
                    .transition(.opacity)
            }
            
            if showOnboarding {
                OnboardingView(narrativeManager: speechViewModel)
                    .transition(.opacity)
            }
        }
        .background(.clear)
        .ignoresSafeArea()
    }
    
    /// Enables sound and updates the selection.
    private func enableSound() {
        selectedSoundOption = .sound
        speechViewModel.isSoundEnabled = true
        isButtonPressed = true
    }

    /// Disables sound and stops all audio.
    private func disableSound() {
        selectedSoundOption = .noSound
        speechViewModel.isSoundEnabled = false
        SoundPlayer.isSoundEnabled = false
        SoundPlayer.stopAllSounds()
        isButtonPressed = true
    }

    /// Starts the transition animation before showing the onboarding screen.
    private func startTransition() {
        withAnimation(.easeInOut(duration: 1.0)) {
            showTransitionScreen = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 1.0)) {
                showOnboarding = true
                showTransitionScreen = false
            }
        }
    }
}
