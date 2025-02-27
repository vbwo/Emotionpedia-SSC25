import SwiftUI
import AVFoundation
import Vision

/// Last step of the level cycle: Activity to express happiness by clapping to the music rhythm.
struct HappyActivityView<Dialogue: DialogueHandler>: View {
    
    @ObservedObject var dialogue: Dialogue
    @EnvironmentObject var musicGame: MusicGameManager
    @EnvironmentObject var celebrationManager: CelebrationManager
    @EnvironmentObject var narrativeManager: NarrativeManager
    
    @State private var showInstructions: Bool = true
    @State private var countdown: Int? = nil
    @Binding var isButtonAvailable: Bool
    @Binding var isGameRunning: Bool
    @Binding var isGameFinished: Bool
    
    init(dialogue: Dialogue, isButtonAvailable: Binding<Bool>, isGameRunning: Binding<Bool>, isGameFinished: Binding<Bool>, celebrationManager: CelebrationManager) {
        self.dialogue = dialogue
        self._isButtonAvailable = isButtonAvailable
        self._isGameRunning = isGameRunning
        self._isGameFinished = isGameFinished
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraComponent(onFrameCaptured: musicGame.processFrame, game: musicGame, cameraPosition: .front)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: geometry.size.width * 0.92, height: geometry.size.height * 0.87)
                
                if isGameRunning {
                    ProgressBarComponent(
                        progress: musicGame.progress,
                        clapStates: musicGame.clapStates,
                        clapTimestamps: musicGame.clapTimestamps,
                        totalDuration: musicGame.audioPlayer?.duration ?? 7.821
                    )
                    .offset(x: 100, y: -50)
                    .transition(.opacity)
                }
                
                if let countdown = countdown {
                    CountdownComponent(emotion: "happy", countdown: countdown, updateCountdown: updateCountdown)
                }
                
                if showInstructions {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color("orangeEmotionpedia"))
                                .frame(width: 330)
                            
                            InstructionsComponent(
                              description: "Tap ‘Start’ to begin and\nclap your hands to the music.",
                              instruction: "Find a bright place;\nAlign your hands as shown;\nClap when the bar reaches the icons.",
                                image: "happyActivityTutorial",
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
                    .position(x: geometry.size.width * 0.54, y: geometry.size.height * 0.39)
                }
                
                CelebrationComponent()
                
                if musicGame.tryAgainButton {
                    RegularButtonComponent(
                        action: {
                            startCountdown()
                            musicGame.tryAgainButton = false
                        },
                        color: Color("yellowEmotionpedia"),
                        text: "Play Again!",
                        width: 280,
                        height: 40
                    )
                    .zIndex(2)
                }
            }
            .onAppear(perform: setupGame)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }

      /// Initializes the game state when the view appears.
      private func setupGame() {
          celebrationManager.reset()
          isButtonAvailable = false

          musicGame.onGameEnd = {
              DispatchQueue.main.async {
                  if !self.musicGame.tryAgainButton { 
                      self.isGameRunning = false
                      self.isButtonAvailable = true
                      self.isGameFinished = true
                      
                      celebrationManager.triggerCelebration()
                  }
              }
          }


      }

      /// Starts the countdown before the game begins.
      private func startCountdown() {
          withAnimation {
              showInstructions = false
              isGameRunning = true
              countdown = 3
              musicGame.clapStates = Array(repeating: false, count: musicGame.clapTimestamps.count)
          }
      }

      /// Updates the countdown each second until it reaches zero.
      private func updateCountdown() {
          if let currentCount = countdown, currentCount > 1 {
              countdown = currentCount - 1
              DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  updateCountdown()
              }
          } else {
              countdown = nil
              musicGame.startGame()
          }
      }
  }
