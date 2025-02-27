import SwiftUI

/// Last step of the level cycle: Activity where the user blows bubbles to reduce the Anger Level.
struct AngryActivityView<Dialogue: DialogueHandler>: View {
    
    @ObservedObject var dialogue: Dialogue
    @EnvironmentObject var breathDetector: BreathDetectorManager
    @EnvironmentObject var bubbleManager: BubbleManager
    @EnvironmentObject var celebrationManager: CelebrationManager
    @EnvironmentObject var narrativeManager: NarrativeManager
    
    @State private var phase: BreathingPhase = .inhaling
    @State private var showInstructions = true
    @State private var startBreathing = false
    @State private var showBubbleToy = false
    @State private var isBreathProcessed = false
    @State private var countdown: Int? = nil
    @State private var angerLevel: Double = 1.0
    @Binding var isGameRunning: Bool
    @Binding var isButtonAvailable: Bool
    @Binding var isGameFinished: Bool
    
    let emotion: Emotion
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraComponent(onFrameCaptured: { _ in }, game: nil, cameraPosition: .back)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: geometry.size.width * 0.92, height: geometry.size.height * 0.87)
                
                if let countdown = countdown {
                    CountdownComponent(emotion: "angry", countdown: countdown, updateCountdown: updateCountdown)
                }
                
                if isGameRunning {
                    if startBreathing {
                        gameContent(geometry: geometry)
                            .onAppear(perform: startActivity)
                    }
                }
                
                if showInstructions {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color("redEmotionpedia"))
                                .frame(width: 330)
                            
                            InstructionsComponent(
                                description: "Inhale on the circle, blow to make\nbubbles and reduce the Anger Level!",
                                instruction: "Breath in as the circle expands;\nBlow to release bubbles!",
                                image: "angryActivityTutorial",
                                onStart: {
                                    startCountdown()
                                    narrativeManager.stopNarration()
                                }
                            )
                            .transition(.opacity)
                        }
                        Spacer()
                    }
                    .frame(height: 480)
                    .position(x: geometry.size.width * 0.565, y: geometry.size.height * 0.39)
                }
                
                CelebrationComponent()
            }
            .onAppear{
                celebrationManager.reset()
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
    /// Starts the breathing activity and detects user's breath.
    private func startActivity() {
        breathDetector.startAudioDetection { isBreathDetected in
            if isBreathDetected && showBubbleToy && !isBreathProcessed {
                processBreath()
            }
        }
    }

    
    /// Handles the countdown before the activity starts.
    private func startCountdown() {
        withAnimation {
            showInstructions = false
            isGameRunning = true
            countdown = 3
        }
    }
    
    /// Updates the countdown each second until reaching zero.
    private func updateCountdown() {
        if let currentCount = countdown, currentCount > 1 {
            countdown = currentCount - 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                updateCountdown()
            }
        } else {
            countdown = nil
            startBreathing = true
        }
    }
    
    /// Processes the breath input, creates bubbles, and updates the anger level bar.
    private func processBreath() {
        isBreathProcessed = true
        bubbleManager.addBubble()
        angerLevel = max(angerLevel - (1.0 / 3.0), 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showBubbleToy = false
            isBreathProcessed = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if angerLevel > 0.01 {
                phase = .inhaling
                startBreathing = true
            } else {
                finishGame()
            }
        }
    }
    
    /// Ends the activity and triggers the celebration.
    private func finishGame() {
        isGameRunning = false
        isGameFinished = true
        isButtonAvailable = true
        celebrationManager.triggerCelebration()
    }
    
    /// Displays the main game content.
    /// - Parameter geometry: A `GeometryProxy` that provides size and coordinate information for layout.
    /// - Returns: A `View` containing the game UI, including the anger meter and either the bubble toy or breathing circle.
    private func gameContent(geometry: GeometryProxy) -> some View {
        ZStack {
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    VStack(spacing: 8) {
                        Text("Anger Level")
                            .applyFontStyle(FontStylesComponent.mainFont, color: Color("whiteEmotionpedia"), size: 32)
                        
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 60)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: .red, location: 0.0),
                                            .init(color: .yellow, location: 0.33),
                                            .init(color: .green, location: 0.66)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 60, height: 400 * CGFloat(angerLevel))
                                .animation(.easeInOut, value: angerLevel)
                            
                            RoundedRectangle(cornerRadius: 60)
                                .stroke(Color("whiteEmotionpedia"), lineWidth: 4)
                                .frame(width: 60, height: 400)
                        }
                    }
                }
            }
            .shadow(radius: 20)
            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
            
            if showBubbleToy {
                BubbleBlowerComponent(bubbles: $bubbleManager.bubbles, text: "Blow the bubbles!")
            }
            else {
                BreathingCircleComponent(phase: $phase, onComplete: {
                    showBubbleToy = true
                })
            }
        }
    }
}
