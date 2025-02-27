import SwiftUI

// MARK: - Enum for Sound Options

/// Represents different sound states in the app.
enum SoundOption {
    case sound
    case noSound
    case none
}

// MARK: - Base Button

//// A reusable button that plays a sound when tapped and executes an action.
struct BaseButtonComponent<Content: View>: View {
    let action: () -> Void
    let content: () -> Content
    
    var body: some View {
        Button(action: {
            SoundPlayer.playButtonSound()
            action()
        }) {
            content()
        }
    }
}

// MARK: - Sound Button

//// A button that toggles between sound and mute states, displaying an icon accordingly.
struct SoundButtonComponent: View {
    let imageName: String?
    let selectedSoundOption: SoundOption
    let action: () -> Void
    let fontStyle: FontProperties
    var size: CGFloat
    var spacing: CGFloat = 8
    var iconHeight: CGFloat = 24
    var isUnderlined: Bool = false
    
    var body: some View {
        BaseButtonComponent(action: action) {
            VStack(spacing: spacing) {
                ZStack {
                    if let imageName = imageName, !imageName.isEmpty {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    Image(systemName: selectedSoundOption == .sound ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: iconHeight)
                        .foregroundStyle(Color("blackEmotionpedia"))
                }
                
                Text(selectedSoundOption == .sound ? "Sound" : "Mute")
                    .applyFontStyle(fontStyle, size: size)
                    .underline(isUnderlined, color: .black)
                
            }
        }
    }
}

// MARK: - Pause Button

//// A button that navigates to the `PauseScreen`, pausing the current activity.
struct PauseButtonComponent: View {
    
    @EnvironmentObject var narrativeManager: NarrativeManager
    @EnvironmentObject var navigationManager: NavigationManager
    
    var onFinish: () -> Void
    var body: some View {
        
        Button(action: {
            navigationManager.isPaused = true
            narrativeManager.stopNarration()
        }) {
            VStack(spacing: 8) {
                Image(systemName: "pause.circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(Color("blackEmotionpedia"))
                Text("Break")
                    .applyFontStyle(FontStylesComponent.mainFont, size: 28)
            }
        }
        .simultaneousGesture(TapGesture().onEnded {
            SoundPlayer.playButtonSound()
        })
    }
}

// MARK: - Regular Button

/// A customizable button with a rounded rectangle shape.
struct RegularButtonComponent: View {
    let action: () -> Void
    let color: Color
    let text: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        BaseButtonComponent(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: width, height: height)
                    .foregroundStyle(color)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.black, lineWidth: 4)
                    )
                Text(text)
                    .applyFontStyle(FontStylesComponent.mainFont, size: 32)
            }
        }
    }
}

// MARK: - Sound and Pause Buttons

//// A horizontal stack containing the sound and pause buttons.
struct SoundAndPauseButtonsComponent: View {
    @State private var selectedSoundOption: SoundOption = .none
    @EnvironmentObject var narrativeManager: NarrativeManager
    var onFinish: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack(spacing: 12) {
                    
                    ZStack {
                        Circle()
                            .foregroundStyle(Color("whiteEmotionpedia"))
                            .frame(width: 72)
                        SoundButtonComponent(
                            imageName: nil,
                            selectedSoundOption: selectedSoundOption,
                            action: {
                                selectedSoundOption = (selectedSoundOption == .sound) ? .noSound : .sound
                                narrativeManager.toggleSound()
                                SoundPlayer.isSoundEnabled = (selectedSoundOption == .sound)
                                if selectedSoundOption == .noSound {
                                    SoundPlayer.stopAllSounds()
                                }
                            },
                            fontStyle: FontStylesComponent.mainFont,
                            size: 28
                        )
                    }
                    
                    ZStack {
                        Circle()
                            .foregroundStyle(Color("whiteEmotionpedia"))
                            .frame(width: 72)
                        PauseButtonComponent(onFinish: onFinish)
                    }
                }
                .padding(.horizontal, 64)
                .padding(.vertical, 16)
                
                Spacer()
            }
        }
        .onAppear {
            selectedSoundOption = narrativeManager.isSoundEnabled ? .sound : .noSound
            SoundPlayer.isSoundEnabled = narrativeManager.isSoundEnabled
        }
    }
}

// MARK: - Navigation Button

/// A button that navigates to the next screen.
struct NavigationButtonComponent: View {
    let action: () -> Void
    let symbol: String
    let text: String
    let circle: Bool
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color("blackEmotionpedia"))
                            .frame(width: 62)
                        Button(action: action) {
                            ZStack {
                                if circle {
                                    Circle()
                                        .foregroundStyle(Color("yellowEmotionpedia"))
                                        .frame(width: 60)
                                }
                                Image(systemName: "\(symbol)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: circle ? 36 : 60)
                                    .foregroundStyle(Color(circle ? "blackEmotionpedia" : "yellowEmotionpedia"))
                            }
                        }
                    }
                    
                    Text("\(text)").applyFontStyle(FontStylesComponent.mainFont, size: 32)
                    
                } .simultaneousGesture(TapGesture().onEnded {
                    SoundPlayer.playButtonSound()
                })
            }
        } .padding(.vertical, 64)
            .padding(.horizontal, 76)
    }
}
