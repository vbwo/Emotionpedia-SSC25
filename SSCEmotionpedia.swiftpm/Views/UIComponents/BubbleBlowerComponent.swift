import SwiftUI

/// Represents an individual bubble with position and scale properties.
struct Bubble: Identifiable, Equatable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var endX: CGFloat
    var endY: CGFloat
    var scale: CGFloat
}

/// Displays a bubble-blowing toy and floating bubbles animation.
struct BubbleBlowerComponent: View {
    @Binding var bubbles: [Bubble]
    var text: String?
    
    var body: some View {
        GeometryReader { geometry in
            if let text = text {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color("whiteEmotionpedia"))
                        .frame(width: 500, height: 80)
                    Text(text)
                        .applyFontStyle(FontStylesComponent.mainFont, color: Color("blackEmotionpedia"), size: 52)
                }
                .shadow(radius: 40)
                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.15)
                
                ZStack {
                    Image("bubbletoy")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 20)
                        .frame(height: 300)
                    
                    ForEach(bubbles) { bubble in
                        Image("bubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .offset(y: -170)
                            .position(x: bubble.x, y: bubble.y)
                            .scaleEffect(bubble.scale)
                            .opacity(Double(bubble.scale))
                            .animation(.easeOut(duration: 2.0), value: bubble)
                    }
                }
                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.75)
            }
        }
    }
}
