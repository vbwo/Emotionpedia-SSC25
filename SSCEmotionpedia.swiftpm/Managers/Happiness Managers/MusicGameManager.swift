import AVFoundation
import SwiftUI

/// Defines the game based on clapping to the music's timestamps.
class MusicGameManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var detectClapping: Bool = false
    @Published var score: Int = 0
    @Published var progress: CGFloat = 0.0
    @Published var currentClapIndex = 0
    @Published var clapStates: [Bool] = []
    @Published var showConfetti: Bool = false
    @Published var showCongratulations: Bool = false
    @Published var tryAgainButton: Bool = false
    
    private var timer: Timer?
    private var clapDetector = ClappingDetectorManager()
    private var isWaitingForClap = false
    private var expectedClapTime: TimeInterval?
    private let celebrationManager: CelebrationManager
    private var gameTimer: Timer?
    private var gameElapsedTime: TimeInterval = 0.0
    var audioPlayer: AVAudioPlayer?
    var onGameEnd: (() -> Void)?
    let tolerance: TimeInterval = 0.4
    let clapTimestamps: [TimeInterval] = [
        0.9, 1.7, 3.1, 4.1, 5.1, 6.2, 6.8, 7.3
    ]

       init(celebrationManager: CelebrationManager) {
           self.celebrationManager = celebrationManager
       }
    
    /// Plays the music for the game, loading the audio file, initializing the AVAudioPlayer, and starting it.
    func playMusic() {
        guard SoundPlayer.isSoundEnabled else { return }
        
        guard let audioPath = Bundle.main.path(forResource: "happyMusic", ofType: "m4a") else { return }
        
        do {
            let url = URL(fileURLWithPath: audioPath)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
        }
    }
    
    /// Starts the game by resetting the state, initializing clap states, and playing the music.
    func startGame() {
        clapStates = Array(repeating: false, count: clapTimestamps.count)
        resetGameState()
        
        if SoundPlayer.isSoundEnabled {
            playMusic()
        }

        gameElapsedTime = 0.0
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.gameElapsedTime += 0.1
            self.updateGameState()
            self.updateProgress()
        }
    }

    
    /// Resets the game state (score, current clap index, and clap waiting status).
    func resetGameState() {
        currentClapIndex = 0
        score = 0
        isWaitingForClap = false
    }
    
    /// Updates the game progress based on the current audio playback time as a percentage of the total music duration.
    func updateProgress() {
        let duration = audioPlayer?.duration ?? clapTimestamps.last ?? 7.821
        progress = min(CGFloat(gameElapsedTime / duration), 1.0)
    }

    
    /// Updates the game state by checking if the player clapped at the correct time.
    /// Compares the current playback time with the expected clap time.
    /// If the player clapped on time, it increments the score and the current clap index.
    func updateGameState() {
        checkAndStartMusic()
        
        let currentTime = gameElapsedTime
        
        if currentClapIndex < clapTimestamps.count {
            let targetTime = clapTimestamps[currentClapIndex]
            
            handleClapDetection(expectedTime: targetTime, currentTime: currentTime)
            handleTimestampOverflow(currentTime: currentTime, targetTime: targetTime)
        }
        
        handleGameCompletion()
    }


    
    /// Handles clap detection logic, including updating score and clap state.
    /// - Parameters:
    ///   - expectedTime: The expected time for the clap.
    ///   - currentTime: The current playback time of the audio.
    private func handleClapDetection(expectedTime: TimeInterval, currentTime: TimeInterval) {
        if detectClapping && isClapOnTime(expectedTime: expectedTime, currentTime: currentTime) {
            clapStates[currentClapIndex] = true
            score += 1
            currentClapIndex += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.detectClapping = false
            }
        }
    }
    
    /// Handles the scenario where the current time exceeds the expected clap time.
    /// - Parameters:
    ///   - currentTime: The current playback time of the audio.
    ///   - targetTime: The expected time for the clap.
    private func handleTimestampOverflow(currentTime: TimeInterval, targetTime: TimeInterval) {
        if currentTime >= targetTime + tolerance {
            currentClapIndex += 1
        }
    }
    
    /// Handles game completion logic, stopping the game if all claps are detected.
    private func handleGameCompletion() {
        if currentClapIndex >= clapTimestamps.count, progress >= 0.97 {
            let detectedClaps = clapStates.filter { $0 }.count
            let requiredClaps = Int(ceil(Double(clapTimestamps.count) / 2.0)) 
            
            if detectedClaps >= requiredClaps {
                stopGame()
            } else {
                DispatchQueue.main.async {
                    withAnimation {
                        self.tryAgainButton = true
                    }
                }
            }
        }
    }

    
    
    /// Checks if the player clapped within the acceptable tolerance range.
    /// - Parameters:
    ///   - expectedTime: The expected time for the clap to occur.
    ///   - currentTime: The current playback time of the music.
    /// - Returns: A boolean indicating if the clap was on time.
    func isClapOnTime(expectedTime: TimeInterval, currentTime: TimeInterval) -> Bool {
        return abs(currentTime - expectedTime) <= tolerance
    }
    
    /// Stops the game by invalidating the timer and stopping the audio player.
    func stopGame() {
        gameTimer?.invalidate()
        gameTimer = nil
        timer?.invalidate()
        timer = nil
        audioPlayer?.stop()
        
        DispatchQueue.main.async {
            self.onGameEnd?()
        }
    }

    
    /// Called when the audio player finishes playing the music and stops the game when the music ends.
    /// - Parameters:
    ///   - player: The AVAudioPlayer instance.
    ///   - flag: A boolean indicating whether the player finished successfully.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopGame()
    }
    
    /// Checks if sound is enabled and starts playing music if it is not already playing.
    func checkAndStartMusic() {
        if SoundPlayer.isSoundEnabled, audioPlayer?.isPlaying == false {
            playMusic()
        }
    }
    
    /// Processes the video frame and detects if the user clapped.
    /// - Parameter frame: The video frame to process for clap detection.
    func processFrame(_ frame: CVPixelBuffer) {
        clapDetector.detectClapping(in: frame)
        
        if clapDetector.userClapped {
            DispatchQueue.main.async {
                self.detectClapping = true
            }
            clapDetector.userClapped = false
        }
    }
}
