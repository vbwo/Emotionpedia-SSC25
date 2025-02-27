import Speech

/// Recognizes spoken numbers and matches them against expected values.
class NumberRecognizerManager: NSObject, ObservableObject {
    
    @Published var recognizedNumber = 0
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    /// Requests speech recognition authorization and starts recognition if granted.
    func startRecognition() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.configureAudioSession()
                    self.startAudioEngine()
                case .denied, .restricted, .notDetermined:
                    print("Permission denied or unavailable.")
                @unknown default:
                    print("Unknown speech recognition status.")
                }
            }
        }
    }
    
    /// Configures the audio session for speech recognition.
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session error: \(error.localizedDescription)")
        }
    }
    
    /// Starts capturing audio for speech recognition.
    private func startAudioEngine() {
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else { return }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            startRecognitionTask()
        } catch {
            print("Audio engine start error: \(error.localizedDescription)")
        }
    }
    
    /// Starts processing the captured speech.
    private func startRecognitionTask() {
        guard let request = request else { return }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            guard let result = result else {
                if let error = error {
                    print("Recognition error: \(error.localizedDescription)")
                }
                return
            }
            self.handleSpokenText(result.bestTranscription)
        }
    }
    
    /// Processes transcribed text to detect spoken numbers.
    /// - Parameter transcription: Transcribed speech input.
    private func handleSpokenText(_ transcription: SFTranscription) {
        if let lastSegment = transcription.segments.last {
            let possibleNumbers = [
                "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
                "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"
            ]
            
            if let index = possibleNumbers.firstIndex(of: lastSegment.substring.lowercased()) {
                DispatchQueue.main.async {
                    let recognizedIndex = (index % 10) + 1
                    if recognizedIndex == self.recognizedNumber + 1 || recognizedIndex == 1 {
                        self.recognizedNumber = recognizedIndex
                    }
                }
            }
        }
    }
    
    /// Stops speech recognition and clears resources.
    func stopRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        request = nil
        recognitionTask = nil
    }
    
    /// Resets recognition and restarts listening.
    func resetRecognition() {
        stopRecognition()
        recognizedNumber = 0
        startRecognition()
    }
}
