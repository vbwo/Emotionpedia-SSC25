import SwiftUI

/// Displays the opening screen with an animated logo and navigation to the next view.
struct OpeningView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject private var narrativeManager: NarrativeManager
    
    @State private var showTransitionScreen = false
    @State private var showSoundView = false
    @State private var currentFrame = 0
    @State private var completedLevels: Set<Level> = []
    
    let frames = ["logo1", "logo2"]
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            ZStack {
                BackgroundComponent(borderColor: "blue")
                
                VStack {
                    if !showTransitionScreen && !showSoundView {
                        Image(frames[currentFrame])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 1000, height: 300)
                            .onReceive(timer) { _ in
                                currentFrame = (currentFrame + 1) % frames.count
                            }
                        
                        Button(action: startTransition) {
                            Text("Tap here to start")
                                .applyFontStyle(FontStylesComponent.mainFont, size: 60)
                                .padding(.top, 40)
                        }
                    }
                }
                
                if showTransitionScreen {
                    BackgroundComponent(borderColor: "blue")
                        .transition(.opacity)
                }
                
                if showSoundView {
                    SoundScreen()
                        .transition(.opacity)
                }
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: String.self) { navigateToView($0) }
            .navigationDestination(for: Level.self) { navigateToLevel($0) }
            .fullScreenCover(isPresented: $navigationManager.isPaused) {
                PauseView()
            }
        }
    }
    
    /// Starts the transition animation before showing the sound screen.
    private func startTransition() {
        withAnimation(.easeInOut(duration: 1.0)) {
            showTransitionScreen = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 1.0)) {
                showTransitionScreen = false
                showSoundView = true
            }
        }
    }
    
    /// Handles navigation between views based on a string identifier.
    /// - Parameter view: The identifier of the target view.
    @ViewBuilder
    private func navigateToView(_ view: String) -> some View {
        switch view {
        case "OpeningView":
            OpeningView()
        case "LevelsView":
            LevelsView()
        case "CreditsView":
            CreditsView()
        case "EndingView":
            EndingView()
        default:
            EmptyView()
        }
    }
    
    /// Handles navigation between level views.
    /// - Parameter level: The selected level.
    @ViewBuilder
    private func navigateToLevel(_ level: Level) -> some View {
        switch level {
        case .happy:
            HappyLevelView(onFinish: { completeLevel(.happy) }, narrativeManager: narrativeManager)
        case .angry:
            AngryLevelView(onFinish: { completeLevel(.angry) }, narrativeManager: narrativeManager)
        }
    }
    
    /// Marks a level as completed and navigates accordingly.
    /// - Parameter level: The completed level.
    private func completeLevel(_ level: Level) {
        navigationManager.completedLevels.insert(level)
        
        if navigationManager.completedLevels.contains(.happy) && navigationManager.completedLevels.contains(.angry) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    navigationManager.path.append("EndingView")
                }
            }
        } else {
            navigationManager.path.append("LevelsView")
        }
    }
}
