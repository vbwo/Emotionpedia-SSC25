import SwiftUI
import AVFoundation

/// Detects and processes the user's breathing for AngryActivity.
class BreathDetectorManager: ObservableObject {
    
    private let audioEngine = AVAudioEngine()
    private var smoothedRMS: Float = 0
    private var lastBreathDetectedTime: TimeInterval = 0
    private let minBreathDuration: TimeInterval = 0.15
    private let highPassThreshold: Float = 0.05
    private let lowPassThreshold: Float = 1.0

    /// Starts monitoring audio input for breath detection.
    /// - Parameter onBreathDetected: Called with `true` when a valid breath is detected.
    func startAudioDetection(onBreathDetected: @escaping (Bool) -> Void) {
        configureAudioSession()
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        guard recordingFormat.sampleRate != 0, recordingFormat.channelCount != 0 else { return }

        inputNode.installTap(onBus: 0, bufferSize: 512, format: recordingFormat) { buffer, _ in
            self.detectBreath(buffer: buffer, onBreathDetected: onBreathDetected)
        }

        do {
            try audioEngine.start()
        } catch {
            print("Audio engine failed: \(error.localizedDescription)")
        }
    }

    /// Configures the audio session for recording and playback.
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.mixWithOthers, .defaultToSpeaker, .allowBluetoothA2DP]
            )
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session error: \(error.localizedDescription)")
        }
    }

    /// Analyzes audio buffer to detect breathing patterns.
    /// - Parameters:
    ///   - buffer: Captured audio data.
    ///   - onBreathDetected: Callback triggered when a breath is detected.
    private func detectBreath(buffer: AVAudioPCMBuffer, onBreathDetected: @escaping (Bool) -> Void) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))

        let rms = sqrt(channelDataArray.map { $0 * $0 }.reduce(0, +) / Float(channelDataArray.count))
        smoothedRMS = (smoothedRMS * 0.85) + (rms * 0.15)

        let currentTime = Date().timeIntervalSince1970
        let isBreathDetected = smoothedRMS > highPassThreshold && smoothedRMS < lowPassThreshold
        let isCooldownOver = (currentTime - lastBreathDetectedTime) > minBreathDuration

        if isBreathDetected && isCooldownOver {
            lastBreathDetectedTime = currentTime
            DispatchQueue.main.async {
                onBreathDetected(true)
            }
        }
    }

    /// Stops audio detection and releases resources.
    func stopAudioDetection() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session deactivation failed: \(error.localizedDescription)")
        }
    }
}
