import Vision
import Combine

/// Detects clapping gestures using the Vision framework.
class ClappingDetectorManager: ObservableObject {
    
    @Published var userClapped = false
    
    private var previousDistances: [CGFloat] = []
    private var lastClapTime: Date?
    private let maxBufferSize = 6
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    private let clapCooldown: TimeInterval = 0.4
    
    /// Analyzes hand poses in a video frame to detect clapping.
    /// - Parameter pixelBuffer: Frame data to be processed.
    func detectClapping(in pixelBuffer: CVPixelBuffer) {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .downMirrored, options: [:])
        
        do {
            try handler.perform([handPoseRequest])
            guard let observations = Array(handPoseRequest.results?.prefix(2) ?? []) as? [VNHumanHandPoseObservation], observations.count == 2 else { return }
            
            guard let handPositions = extractHandPositions(from: observations) else { return }
            let wristDistance = calculateHandDistance(for: handPositions.map { $0.0 })
            let fingerDistance = calculateHandDistance(for: handPositions.map { $0.1 })
            
            updatePreviousDistances(with: wristDistance)
            
            if areHandsAligned(handPositions: handPositions, wristDistance: wristDistance, fingerDistance: fingerDistance),
               isClapMotionDetected(),
               canTriggerClap() {
                lastClapTime = Date()
                DispatchQueue.main.async {
                    self.userClapped = true
                }
            }
        } catch {
            print("Hand detection error: \(error)")
        }
    }
    
    /// Extracts wrist and pinky tip positions for accurate clap detection.
    /// - Parameter observations: Detected hand poses.
    /// - Returns: Tuple with wrist and pinky tip positions if two hands are detected.
    private func extractHandPositions(from observations: [VNHumanHandPoseObservation]) -> [(CGPoint, CGPoint)]? {
        var handPositions: [(CGPoint, CGPoint)] = []
        let confidenceThreshold: Float = 0.15
        
        for observation in observations {
            let points = try? observation.recognizedPoints(.all)
            
            if let wrist = points?[.wrist], let littleTip = points?[.littleTip],
               wrist.confidence > confidenceThreshold, littleTip.confidence > confidenceThreshold {
                let wristPoint = CGPoint(x: wrist.location.x, y: 1 - wrist.location.y)
                let littleTipPoint = CGPoint(x: littleTip.location.x, y: 1 - littleTip.location.y)
                handPositions.append((wristPoint, littleTipPoint))
            }
        }
        
        return handPositions.count == 2 ? handPositions : nil
    }
    
    /// Calculates the distance between two points.
    private func calculateHandDistance(for points: [CGPoint]) -> CGFloat {
        return hypot(points[0].x - points[1].x, points[0].y - points[1].y)
    }

    /// Updates the history of hand distances for motion analysis.
    private func updatePreviousDistances(with distance: CGFloat) {
        previousDistances.append(distance)
        if previousDistances.count > maxBufferSize {
            previousDistances.removeFirst()
        }
    }

    /// Checks if the hand movement matches a clapping motion.
    private func isClapMotionDetected() -> Bool {
        guard previousDistances.count == maxBufferSize else { return false }
        
        let firstDistance = previousDistances.first!
        let midDistance = previousDistances[maxBufferSize / 2]
        let lastDistance = previousDistances.last!
        
        let isClosingFast = (firstDistance - midDistance) > 0.12
        let isVeryClose = midDistance < 0.15
        let staysClosed = lastDistance < 0.12
        
        return isClosingFast && isVeryClose && (staysClosed || (lastDistance - midDistance) > 0.03)
    }

    /// Ensures hands are aligned to prevent false positives.
    private func areHandsAligned(handPositions: [(CGPoint, CGPoint)], wristDistance: CGFloat, fingerDistance: CGFloat) -> Bool {
        let maxVerticalDifference: CGFloat = 0.5
        let verticalDistance = abs(handPositions[0].0.y - handPositions[1].0.y)
        let isHorizontallyAligned = abs(wristDistance - fingerDistance) < 20
        let isVerticallyAligned = verticalDistance < maxVerticalDifference
        return isHorizontallyAligned && isVerticallyAligned
    }

    /// Ensures a minimum time interval between claps to prevent duplicate detections.
    private func canTriggerClap() -> Bool {
        guard let lastTime = lastClapTime else { return true }
        return Date().timeIntervalSince(lastTime) > clapCooldown
    }
}
