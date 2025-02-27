import SwiftUI

/// Displays the coordinator's captured image as a prize after completing the level, allowing the child to save, print, or keep the photo as a reminder of the emotion.
struct EmotionPrizeView: View {
    
    @EnvironmentObject var narrativeManager: NarrativeManager
    @EnvironmentObject var coordinator: ARCoordinatorManager
    
    @State private var localImage: UIImage? = nil
    @State private var isSaved = false
    
    var emotion: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Text("You did it!")
                        .applyFontStyle(FontStylesComponent.secondaryFont, color: emotion == "happy" ? Color("orangeEmotionpedia") : Color("redEmotionpedia"), size: 80)
                    
                    Text("Here is your prize for concluding \"\(emotion)\":")
                        .applyFontStyle(FontStylesComponent.mainFont, size: 40)
                    
                    if let capturedImage = coordinator.capturedImage {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: capturedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400)
                                .mask {
                                    RoundedRectangle(cornerRadius: 20)
                                }
                            
                            Image("award")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .rotationEffect(.degrees(-30))
                                .offset(x: 32, y: -20)
                            
                        }
                        .offset(y: 12)
                        
                        RegularButtonComponent(action: {
                            saveImageToGallery(image: capturedImage)
                        }, color: Color("blueEmotionpedia"),
                                      text: isSaved ? "Image Saved!" : "Save Image",
                                      width: 200,
                                      height: 44
                                      
                        )
                        .disabled(isSaved)
                        .offset(y: 28)
                    }
                    
                }
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2.5)
            .background(.clear)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    
    /// Saves the images to user's gallery,
    /// - Parameter image: The avaliable image to save.
    func saveImageToGallery(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        isSaved = true
    }
}

