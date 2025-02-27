import SwiftUI
import AVFoundation

/// A camera component that captures frames for different activities, supporting both front and back cameras.
/// Used in `HappyActivity` for clap detection and in `AngryActivity` as a background for bubble-blowing.
struct CameraComponent: UIViewControllerRepresentable {
    var onFrameCaptured: (CVPixelBuffer) -> Void
    var game: MusicGameManager?
    var cameraPosition: AVCaptureDevice.Position
    
    /// Creates the camera manager responsible for handling the video feed.
    /// - Parameter context: The SwiftUI context.
    /// - Returns: An `ActivityCameraManager` instance.
    func makeUIViewController(context: Context) -> ActivityCameraManager {
        return ActivityCameraManager(onFrameCaptured: onFrameCaptured, game: game, cameraPosition: cameraPosition)
    }
    
    /// Updates the camera manager when the SwiftUI view changes.
    /// - Parameters:
    ///   - uiViewController: The `ActivityCameraManager` instance.
    ///   - context: The SwiftUI context.
    func updateUIViewController(_ uiViewController: ActivityCameraManager, context: Context) {}
}
