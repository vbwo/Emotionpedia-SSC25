import SwiftUI

/// Defines font properties such as type, default color, and size.
struct FontProperties {
    let font: CustomFonts
    let defaultColor: Color
    let defaultSize: CGFloat
}

/// Predefined font styles used throughout the app.
struct FontStylesComponent {
    
    static let mainFont = FontProperties(
        font: .mainFont,
        defaultColor: Color("blackEmotionpedia"),
        defaultSize: 24
    )
    
    static let secondaryFont = FontProperties(
        font: .secondaryFont,
        defaultColor: Color("blackEmotionpedia"),
        defaultSize: 68
    )
    
    static let tertiaryFont = FontProperties(
        font: .tertiaryFont,
        defaultColor: Color(.white),
        defaultSize: 80
    )
}

extension Text {
    
    /// Applies a font style with optional custom color and size.
    /// - Parameters:
    ///   - style: The predefined font style.
    ///   - color: Optional custom color.
    ///   - size: Optional custom size.
    /// - Returns: A styled `Text` view.
    func applyFontStyle(
        _ style: FontProperties,
        color: Color? = nil,
        size: CGFloat? = nil
    ) -> Text {
        self.font(.custom(style.font.fontName, size: size ?? style.defaultSize))
            .foregroundColor(color ?? style.defaultColor)
    }
}
