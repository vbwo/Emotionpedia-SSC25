import SwiftUI

/// A reusable section for displaying credits.
struct CreditSectionComponent: View {
    var title: String
    var items: [CreditItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .applyFontStyle(FontStylesComponent.secondaryFont, color: Color("blueEmotionpedia"), size: 40)
            
            ForEach(items, id: \.text) { item in
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.text)
                        .applyFontStyle(FontStylesComponent.mainFont) +
                    Text(item.linkText)
                        .applyFontStyle(FontStylesComponent.tertiaryFont, color: .blue, size: 28)
                    
                    if let licenseText = item.licenseText, let licenseLinkText = item.licenseLinkText {
                        Text(licenseText)
                            .applyFontStyle(FontStylesComponent.mainFont) +
                        Text(licenseLinkText)
                            .applyFontStyle(FontStylesComponent.tertiaryFont, color: .blue, size: 28)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

/// Represents an individual credit item with text, a link, and optional license details.
struct CreditItem {
    var text: String
    var linkText: String
    var licenseText: String? = nil
    var licenseLinkText: String? = nil
}
