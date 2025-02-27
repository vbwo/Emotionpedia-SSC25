import SwiftUI

/// Displays credits for development, sound effects, fonts, and external contributions.
struct CreditsView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundComponent(borderColor: "blue")
                
                VStack(alignment: .leading, spacing: 40) {
                    
                    HStack {
                        VStack(spacing: 20) {
                            Text("Development")
                                .applyFontStyle(FontStylesComponent.secondaryFont, color: Color("blueEmotionpedia"), size: 40)
                            
                            Image("developer")
                                .resizable()
                                .scaledToFit()
                                .mask {
                                    Circle()
                                        .scaledToFit()
                                        .frame(width: 180)
                                }
                                .shadow(radius: 8)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Vitoria Beltrao")
                                .applyFontStyle(FontStylesComponent.mainFont, size: 36)
                            
                            Spacer()
                                .frame(height: 20)
                            
                            Text("""
                            - Developed Emotionpedia;
                            - Designed and illustrated the project;
                            - Created the Happy Activity music on GarageBand.
                            """)
                            .applyFontStyle(FontStylesComponent.mainFont, size: 24)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(8)
                        }
                        .offset(x: 12, y: 28)
                    }
                    
                   
                    HStack(alignment: .top, spacing: 40) {
                        
                        CreditSectionComponent(title: "Sound Effects", items: [
                            CreditItem(text: "- \"Success\" sound by Andy Rhode – Available on ", linkText: "Freesound"),
                            CreditItem(text: "  Licensed under\u{200B} ", linkText: "CC BY 3.0"),

                            CreditItem(text: "- \"Tap\" sound by Saroop Daiya – Available on ", linkText: "Freesound"),
                            CreditItem(text: "  Licensed under ", linkText: "CC0 1.0 (Public Domain)")
                        ])


                        CreditSectionComponent(title: "Fonts", items: [
                            CreditItem(text: "- Gribouille by Celia Astori – Available on ", linkText: "DaFont "),
                            CreditItem(text: "- Handwriting by user \"athy!!\" – Available on ", linkText: "DaFont"),
                            CreditItem(text: "- Cutesy by Jeron Aguinaldo – Available on ", linkText: "DaFont")
                        ])

                    }
                    
                    CreditSectionComponent(title: "Confetti", items: [
                        CreditItem(text: "- Confetti Animation based on a tutorial by Jared Cassoutt on ", linkText: "\"SwiftUI Tutorials - Designing a Dynamic Confetti Effect\"")
                    ])
                    
                    
                    HStack(alignment: .bottom, spacing: 52) {
                        CreditSectionComponent(title: "External Code", items: [
                            CreditItem(text: "- External Font - Registration Code by Alessandra Luana Nascimento Pereira under ", linkText: "MIT License")
                        ])
                        
                        RegularButtonComponent(
                            action: {
                                navigationManager.path.removeLast()
                            },
                            color: Color("yellowEmotionpedia"),
                            text: "Return",
                            width: 160,
                            height: 40)
                        .offset(y: 10)
                    }
                    
                }
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.85)
                
            } .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
        }
    }
}
