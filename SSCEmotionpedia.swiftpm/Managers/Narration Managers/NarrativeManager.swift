import AVFoundation

/// Defines the interface for handling dialogue interactions.
protocol DialogueHandler: ObservableObject {
    var currentDialogue: String { get set }
    var currentBrainImage: String { get set }
    var isFirstDialogueActive: Bool { get set }
    
    func handleItemTap(item: String)
    func continueDialogue()
    func resetDialogue()
}

/// Manages narration using AVSpeechSynthesizer.
class NarrativeManager: ObservableObject {
    
    @Published var isSoundEnabled = false
    let synthesizer = AVSpeechSynthesizer()
    
    /// Narrates the provided text with a defined voice.
    /// - Parameter text: The text to be narrated.
    func narrate(text: String) {
        SoundPlayer.setupAudioSession()
        
        guard isSoundEnabled else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice.speechVoices()
            .first(where: { $0.language == "en-US" && $0.quality == .enhanced })
            ?? AVSpeechSynthesisVoice(language: "en-US")
        
        utterance.rate = 0.53
        utterance.pitchMultiplier = 2
        utterance.volume = 1
        
        synthesizer.speak(utterance)
    }
    
    /// Toggles narration on or off and stops speech if disabled.
    func toggleSound() {
        isSoundEnabled.toggle()
        if !isSoundEnabled {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    /// Stops the narration.
    func stopNarration() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    /// Narrates dialogue with an optional delay.
    /// - Parameters:
    ///   - text: The text to be narrated.
    ///   - delay: Time delay before narration starts (default: 0.1s).
    func narrateDialogue(_ text: String, delay: TimeInterval = 0.1) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard self.isSoundEnabled else { return }
            self.narrate(text: text)
        }
    }
}
