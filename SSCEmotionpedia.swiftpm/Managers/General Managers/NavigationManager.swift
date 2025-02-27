import SwiftUI

/// Manages navigation and level progression.
class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var completedLevels: Set<Level> = []
    @Published var currentLevel: Level? = nil
    @Published var currentStage: AnyHashable? = nil
    @Published var isPaused = false
}
