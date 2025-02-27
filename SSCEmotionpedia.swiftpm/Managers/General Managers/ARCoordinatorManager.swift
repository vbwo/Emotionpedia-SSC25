import RealityKit
import ARKit

enum EmotionLevel {
    case happy
    case angry
    case none
}

/// Controls the AR session, detects facial expressions, and captures images with decorations.
class ARCoordinatorManager: NSObject, ARSessionDelegate, ObservableObject {
    
    @Published var capturedImage: UIImage?
    @Published var faceTracking: FaceTrackingManager
    @Published var isTrackingActive: Bool = false
    @Published var currentLevel: EmotionLevel = .none
    
    weak var arView: ARView?
    
    init(faceTracking: FaceTrackingManager) {
        self.faceTracking = faceTracking
        super.init()
        
        faceTracking.onEmotionCaptured = { [weak self] emotion in
            guard let self = self, let arView = self.arView else { return }
            self.captureFrameWithEmotion(arView: arView, emotion: emotion)
        }
    }
    
    /// Runs when the AR session detects face changes.
    /// - Parameters:
    ///   - session: The AR session running face tracking.
    ///   - anchors: Updated face data with facial movement information.
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard isTrackingActive else { return }
        
        for anchor in anchors {
            if let faceAnchor = anchor as? ARFaceAnchor {
                faceTracking.processFaceExpression(faceAnchor: faceAnchor, currentLevel: currentLevel)
            }
        }
    }
    
    
    /// Takes a screenshot of the ARView and adds an emotion decoration.
    /// - Parameters:
    ///   - arView: The ARView displaying facial expressions.
    ///   - emotion: The detected emotion ("happy" or "angry").
    func captureFrameWithEmotion(arView: ARView, emotion: String) {
        guard (currentLevel == .happy && emotion == "happy") ||
                (currentLevel == .angry && emotion == "angry") else { return }
        
        arView.snapshot(saveToHDR: false) { [weak self] image in
            guard let self = self, let image = image else { return }
            
            let emotionImageName = (emotion == "happy") ? "happyPrize" : "angryPrize"
            let processedImage = self.addImageDecoration(image: image, emotionImageName: emotionImageName)
            
            DispatchQueue.main.async {
                self.capturedImage = processedImage
            }
        }
    }
    
    /// Sets the current emotion level.
    func setLevel(_ level: EmotionLevel) {
        DispatchQueue.main.async {
            self.currentLevel = level
        }
    }
    
    /// Stops tracking and resets the detected emotion.
    func resetTracking() {
        DispatchQueue.main.async {
            self.isTrackingActive = false
            self.faceTracking.currentEmotion = ""
        }
    }
    
    /// Adds an emotion decoration to the captured image.
    /// - Parameters:
    ///   - image: The original screenshot.
    ///   - emotionImageName: The decoration image name.
    /// - Returns: The processed image with the decoration.
    private func addImageDecoration(image: UIImage, emotionImageName: String) -> UIImage {
        guard let emotionImage = UIImage(named: emotionImageName) else {
            return image
        }
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { context in
            image.draw(at: .zero)
            
            let newSize = CGSize(
                width: emotionImage.size.width / 2.8,
              height: emotionImage.size.height / 2.8
            )
            
            let imagePoint = CGPoint(
                x: (image.size.width - newSize.width) / 2,
                y: image.size.height - newSize.height - 20
            )
            
            emotionImage.draw(in: CGRect(origin: imagePoint, size: newSize))
        }
    }
    
    
}
