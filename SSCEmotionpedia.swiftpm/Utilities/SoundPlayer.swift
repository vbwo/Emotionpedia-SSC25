import AVFoundation

/// Plays sound effects in the app using AVAudioPlayer.
class SoundPlayer: ObservableObject {
    
     static var audioPlayer: AVAudioPlayer?
     static var isSoundEnabled: Bool = true
    
    /// Plays the button sound effect.
    static func playButtonSound() {
        playSound(named: "tapSFX", type: "wav")
    }
    
    /// Plays the success sound effect.
    static func playSuccessSound() {
        playSound(named: "successSFX", type: "wav")
    }
    
    /// Sets up the audio session for playback while allowing mixing with other audio sources.
    static func setupAudioSession() {
           do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
               try AVAudioSession.sharedInstance().setActive(true)
           } catch {
               print("AVAudioSession error: \(error.localizedDescription)")
           }
       }
    
    /// Plays a sound given its name and file type.
    /// - Parameters:
    ///   - soundName: The name of the sound file (without extension).
    ///   - type: The file extension/type (e.g., "wav").
    static func playSound(named soundName: String, type: String) {
        guard isSoundEnabled else { return }
        guard let audioPath = Bundle.main.path(forResource: soundName, ofType: type) else {
            return
        }

        do {
            let url = URL(fileURLWithPath: audioPath)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
        }
    }
    
    /// Stops all app sounds when audio is muted.
    static func stopAllSounds() {
        audioPlayer?.stop()
    }
    
}
