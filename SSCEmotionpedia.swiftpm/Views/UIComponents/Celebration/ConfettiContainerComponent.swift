import SwiftUI

/// Container for the confetti animation, allowing multiple confetti pieces to be displayed.
struct ConfettiContainerComponent: View {
    var count: Int = 70
    @State private var yPosition: CGFloat = 0
    @State private var xPosition: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<count, id: \.self) { _ in
                ConfettiComponent()
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: yPosition != 0 ? CGFloat.random(in: 0...geometry.size.height) : yPosition
                    )
            }
            .onAppear {
                yPosition = CGFloat.random(in: 0...geometry.size.height)
            }
        }
    }
}
