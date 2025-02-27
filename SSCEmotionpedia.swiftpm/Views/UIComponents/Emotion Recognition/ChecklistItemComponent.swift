import SwiftUI

/// Represents an individual item in the facial feature checklist.
struct ChecklistItemComponent: View {
    var title: String
    var bodyText: String
    
    @Binding var isChecked: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color("whiteEmotionpedia"))
                .frame(width: 44)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .underline()
                    .applyFontStyle(FontStylesComponent.mainFont, color: Color("whiteEmotionpedia"))
                Text(bodyText)
                    .applyFontStyle(FontStylesComponent.mainFont, color: Color("whiteEmotionpedia"))
            }
        }
    }
}
