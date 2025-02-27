import SwiftUI

/// Displays an image and label representing a game level (Happy or Angry).
struct LevelImagesComponent: View {
    var imageName: String
    var imageSize: CGFloat
    var levelName: String
    
    var body: some View {
        VStack(spacing: 32) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize)
            
            Text(levelName)
                .applyFontStyle(FontStylesComponent.mainFont, size: 36)
        }
    }
}
