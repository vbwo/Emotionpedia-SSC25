import SwiftUI

/// Displays the anger level as a progress bar.
struct AngerLevelBarComponent: View {
    let angerLevel: Double
    
    var body: some View {
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
