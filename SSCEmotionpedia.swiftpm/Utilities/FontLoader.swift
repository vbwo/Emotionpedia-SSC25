import SwiftUI

/// Responsible for registering a custom font during app launch.
class customFontLoader {
    @MainActor static let shared = FontLoader()
    
    /// Registers the custom font ("Handwriting-Regular.otf") for the application.
    func customFont() {
        if let cfURL = Bundle.main.url(forResource: "Handwriting-Regular", withExtension: "otf") as CFURL? {
            CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        }
    }
}
