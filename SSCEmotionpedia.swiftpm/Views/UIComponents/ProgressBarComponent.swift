import SwiftUI

/// Displays a progress bar that visually tracks the music game's progress based on time and clap detection.
struct ProgressBarComponent: View {
    var progress: CGFloat
    var clapStates: [Bool]
    var clapTimestamps: [TimeInterval]
    var totalDuration: TimeInterval
    
    @EnvironmentObject var musicGame: MusicGameManager
    
    var body: some View {
        VStack {
            Spacer()
            GeometryReader { geometry in
                let barWidth = geometry.size.width - 200
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color("whiteEmotionpedia"))
                        .frame(width: barWidth, height: 32)
                    
                    Rectangle()
                        .fill(Color("orangeEmotionpedia"))
                        .frame(width: barWidth * progress, height: 32)
                        .animation(.linear, value: progress)
                }
                .frame(height: 50)
                
                ZStack {
                    ForEach(clapTimestamps.indices, id: \.self) { index in
                        let timestamp = clapTimestamps[index]
                        let position = barWidth * CGFloat(timestamp / (totalDuration > 0 ? totalDuration : 1.0))
                        
                        ZStack {
                            Circle()
                                .foregroundStyle(Color("whiteEmotionpedia"))
                                .scaledToFit()
                                .frame(width: 50)
                            
                            Image(systemName: clapStates.indices.contains(index) && clapStates[index] ? "checkmark.circle.fill" : "hands.clap.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .foregroundColor(clapStates.indices.contains(index) && clapStates[index] ? .green : Color("blackEmotionpedia"))
                        }
                        .position(x: position, y: 20)
                        .animation(.easeInOut, value: progress)
                    }
                }
            }
            .frame(height: 80)
        }
    }
}
