import SwiftUI
import CoreText

/// Defines the names and types of custom fonts to be used in the application.
enum CustomFonts: String, CaseIterable {
    case mainFont = "Handwriting-Regular.otf"
    case secondaryFont = "Gribouille.ttf"
    case tertiaryFont = "Cutesy.ttf"
    
    var fontName: String { String(self.rawValue.dropLast(4)) }
    var fileExtension: String { String(self.rawValue.suffix(3)) }
}

/// Responsible for registering custom fonts in the application.
class FontLoader {
    static func registerFonts() {
        CustomFonts.allCases.forEach {
            registerFont(fontName: $0.fontName, fontExtension: $0.fileExtension)
        }
    }
    
    /// Registers a single font by loading its data and using Core Text to register it in the system.
    /// - Parameters:
    ///   - fontName: Name of the font without the file extension.
    ///   - fontExtension: File extension of the font (e.g., "otf", "ttf").
    private static func registerFont(fontName: String, fontExtension: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("Couldn't create \(fontName) from data")
            return
        }
        
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}

// MARK: - License

/* MIT License
 Copyright (c) 2022 Alessandra Luana Nascimento Pereira
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 */
