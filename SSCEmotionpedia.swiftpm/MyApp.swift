import SwiftUI

@main
struct MyApp: App {
    
    @StateObject private var narrativeSpeech = NarrativeManager()
    @StateObject private var clapDetection = ClappingDetectorManager()
    @StateObject private var musicGame = MusicGameManager(celebrationManager: CelebrationManager())
    @StateObject private var breathDetector = BreathDetectorManager()
    @StateObject private var coordinator = ARCoordinatorManager(faceTracking: FaceTrackingManager())
    @StateObject private var celebrationManager = CelebrationManager()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var bubbleManager = BubbleManager()
       
    
    init() {
        FontLoader.registerFonts()
        SoundPlayer.setupAudioSession()
    }
    
    var body: some Scene {
        WindowGroup {
            OpeningView()
                .environmentObject(narrativeSpeech)
                .environmentObject(clapDetection)
                .environmentObject(musicGame)
                .environmentObject(breathDetector)
                .environmentObject(coordinator)
                .environmentObject(celebrationManager)
                .environmentObject(navigationManager)
                .environmentObject(bubbleManager)
        }
    }
}
