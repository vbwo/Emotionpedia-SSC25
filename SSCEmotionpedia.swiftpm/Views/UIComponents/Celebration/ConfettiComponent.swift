import SwiftUI

/// This view displays a confetti effect with randomly generated colors and 3D rotation animations.
struct ConfettiComponent: View {
    @State private var animate = false
    @State private var xSpeed = Double.random(in: 0.7...2)
    @State private var zSpeed = Double.random(in: 1...2)
    @State private var anchor = CGFloat.random(in: 0...1).rounded()
    
    private let colors: [Color] = [.orange, .green, .blue, .red, .yellow]
    
    var body: some View {
        Rectangle()
            .fill(colors.randomElement() ?? .orange)
            .frame(width: 8, height: 20)
            .onAppear { animate = true }
            .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 0, y: 0, z: 1), anchor: UnitPoint(x: anchor, y: anchor))
           
            .animation(
                Animation.linear(duration: zSpeed).repeatForever(autoreverses: false),
                value: animate
            )
    }
}
