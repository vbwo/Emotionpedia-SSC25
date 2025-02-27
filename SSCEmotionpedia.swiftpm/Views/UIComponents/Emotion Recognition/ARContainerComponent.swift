import SwiftUI
import RealityKit
import ARKit

/// Creates and manages an ARView, delegating AR session handling to a Coordinator.
struct ARViewComponent: UIViewRepresentable {
    
    @EnvironmentObject var coordinator: ARCoordinatorManager
    
    /// Creates and configures the ARView for face tracking.
    /// - Parameter context: The view context.
    /// - Returns: A configured ARView instance.
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(arConfig, options: .resetTracking)
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        coordinator.arView = arView
        return arView
    }
    
    /// Updates the ARView when needed.
    func updateUIView(_ uiView: ARView, context: Context) {}

    /// Pauses the AR session when the view is removed.
    /// - Parameter uiView: The ARView instance.
    func dismantleUIView(_ uiView: ARView, context: Context) {
        uiView.session.pause()
    }
    
    /// Returns the shared Coordinator instance to manage AR session updates.
    func makeCoordinator() -> ARCoordinatorManager {
        return coordinator
    }
}
