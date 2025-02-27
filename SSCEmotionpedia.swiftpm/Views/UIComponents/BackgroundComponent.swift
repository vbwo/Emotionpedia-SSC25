import SwiftUI

/// Background used in all views.
struct BackgroundComponent: View {
    var borderColor: String
    
    var body: some View {
        Color("whiteEmotionpedia")
            .ignoresSafeArea()
        
        Border(topImage: "top\(borderColor)", bottomImage: "bottom\(borderColor)", leftImage: "left\(borderColor)", rightImage: "right\(borderColor)")
    }
}

/// Borders used in background.
struct Border: View {
    let topImage: String
    let bottomImage: String
    let leftImage: String
    let rightImage: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Image(topImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Spacer()
                    
                    Image(bottomImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                }

                HStack {
                    Image(leftImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height)
                    
                    Spacer()
                    
                    Image(rightImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height)
                }
            }
        }
    }
}
