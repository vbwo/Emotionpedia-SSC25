import SwiftUI
import ARKit

/// Detects emotions using ARKit's face tracking and blend shapes.
/// Determines if the user is happy or angry based on facial expressions.
class FaceTrackingManager: ObservableObject {
    
    @Published var isEyebrowChecked = false
    @Published var isEyeChecked = false
    @Published var isCheekChecked = false
    @Published var isHappyMouthChecked = false
    @Published var isAngryMouthChecked = false
    @Published var isNoseChecked = false
    
    @Published var currentEmotion: String? = nil
    @Published var currentFaceAnchor: ARFaceAnchor?
    @Published var lastDetectedEmotion: String? = nil
    
    var onEmotionCaptured: ((String) -> Void)?
    private var isCapturing = false
    
    /// Processes facial expressions and updates the detected emotion.
    /// - Parameters:
    ///   - faceAnchor: The `ARFaceAnchor` containing blend shape data.
    ///   - currentLevel: The expected emotion level.
    func processFaceExpression(faceAnchor: ARFaceAnchor, currentLevel: EmotionLevel) {
        guard !isCapturing else { return }
        
        detectEmotion(faceAnchor: faceAnchor, currentLevel: currentLevel) { [weak self] newEmotion in
            guard let self = self, let newEmotion = newEmotion else { return }
            if newEmotion != self.currentEmotion {
                self.currentEmotion = newEmotion
            }
        }
    }
    
    /// Detects an emotion based on facial expressions.
    /// - Parameters:
    ///   - faceAnchor: The `ARFaceAnchor` containing blend shape data.
    ///   - currentLevel: The expected emotion level.
    ///   - completion: Callback with the detected emotion or `nil`.
    private func detectEmotion(faceAnchor: ARFaceAnchor, currentLevel: EmotionLevel, completion: @escaping (String?) -> Void) {
        if isAngryExpression(faceAnchor: faceAnchor) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion("angry")
            }
        } else if isHappyExpression(faceAnchor: faceAnchor) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion("happy")
            }
        } else {
            completion(nil)
        }
    }
    
    /// Captures the detected emotion and triggers the callback.
    /// - Parameters:
    ///   - detectedEmotion: The identified emotion.
    ///   - currentLevel: The expected emotion level.
    private func captureEmotionFrame(_ detectedEmotion: String, currentLevel: EmotionLevel) {
        guard let onEmotionCaptured = onEmotionCaptured else { return }
        
        if (currentLevel == .happy && detectedEmotion == "happy") ||
            (currentLevel == .angry && detectedEmotion == "angry") {
            
            currentEmotion = detectedEmotion
            isCapturing = true
            onEmotionCaptured(detectedEmotion)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isCapturing = false
            }
        }
    }
    
    /// Checks if specified blend shape values exceed the threshold.
    /// - Parameters:
    ///   - faceAnchor: The `ARFaceAnchor` containing blend shape data.
    ///   - left: The primary blend shape location.
    ///   - right: (Optional) The secondary blend shape for symmetry.
    ///   - threshold: The minimum required value.
    /// - Returns: `true` if the blend shapes exceed the threshold.
    private func checkBlendShapes(faceAnchor: ARFaceAnchor,
                                  _ left: ARFaceAnchor.BlendShapeLocation,
                                  _ right: ARFaceAnchor.BlendShapeLocation? = nil,
                                  threshold: Float) -> Bool {
        let blendShapes = faceAnchor.blendShapes
        guard let leftValue = blendShapes[left]?.floatValue else { return false }
        let rightValue = right != nil ? blendShapes[right!]?.floatValue ?? 0 : 0
        
        return leftValue > threshold && (right == nil || rightValue > threshold)
    }
    
    /// Determines if the user is making a happy expression.
    /// - Parameter faceAnchor: The `ARFaceAnchor` containing blend shape data.
    /// - Returns: `true` if a happy expression is detected.
    private func isHappyExpression(faceAnchor: ARFaceAnchor) -> Bool {
        let mouthCheck = checkBlendShapes(faceAnchor: faceAnchor, .mouthSmileLeft, .mouthSmileRight, threshold: 0.7)
        let cheekCheck = checkBlendShapes(faceAnchor: faceAnchor, .cheekSquintLeft, .cheekSquintRight, threshold: 0.15)
        let eyeCheck = checkBlendShapes(faceAnchor: faceAnchor, .eyeSquintLeft, .eyeSquintRight, threshold: 0.1)
        
        if mouthCheck && cheekCheck && eyeCheck {
            isHappyMouthChecked = true
            isCheekChecked = true
            isEyeChecked = true
            captureEmotionFrame("happy", currentLevel: .happy)
        } else {
            isHappyMouthChecked = mouthCheck
            isCheekChecked = cheekCheck
            isEyeChecked = eyeCheck
        }
        
        return isHappyMouthChecked && isCheekChecked && isEyeChecked
    }
    
    /// Determines if the user is making an angry expression.
    /// - Parameter faceAnchor: The `ARFaceAnchor` containing blend shape data.
    /// - Returns: `true` if an angry expression is detected.
    private func isAngryExpression(faceAnchor: ARFaceAnchor) -> Bool {
        let mouthTensionCheck = checkBlendShapes(faceAnchor: faceAnchor, .mouthPucker, threshold: 0.3) ||
                                checkBlendShapes(faceAnchor: faceAnchor, .mouthFunnel, threshold: 0.3)
        let mouthCheck = checkBlendShapes(faceAnchor: faceAnchor, .mouthUpperUpLeft, .mouthUpperUpRight, threshold: 0.2) &&
                         checkBlendShapes(faceAnchor: faceAnchor, .mouthLowerDownLeft, .mouthLowerDownRight, threshold: 0.2)
        let eyebrowCheck = checkBlendShapes(faceAnchor: faceAnchor, .browDownLeft, .browDownRight, threshold: 0.3)
        let noseCheck = checkBlendShapes(faceAnchor: faceAnchor, .noseSneerLeft, .noseSneerRight, threshold: 0.2)
        
        if (mouthCheck || mouthTensionCheck) && eyebrowCheck && noseCheck {
            isAngryMouthChecked = true
            isEyebrowChecked = true
            isNoseChecked = true
            captureEmotionFrame("angry", currentLevel: .angry)
        } else {
            isAngryMouthChecked = mouthCheck || mouthTensionCheck
            isEyebrowChecked = eyebrowCheck
            isNoseChecked = noseCheck
        }
        
        return isAngryMouthChecked && isEyebrowChecked && isNoseChecked
    }
}
