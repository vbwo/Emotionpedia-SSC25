import SwiftUI

/// Creates a layered background for EmotionSituationView.
struct SituationBackgroundComponent: View {
    let geometry: GeometryProxy
    let first: String
    let second: String?
    let secondHeightRatio: CGFloat?

    var body: some View {
        ZStack {
          
            Image(first)
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width, height: geometry.size.height)

            if let second = second, let secondHeightRatio = secondHeightRatio {
                Image(second)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height * secondHeightRatio)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.65)
            }
        } 
    }
}
