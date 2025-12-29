
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    // Background
    let backgroundTop = Color(hex: "0D0D1A")
    let backgroundMiddle = Color(hex: "1A1A2E")
    let backgroundBottom = Color(hex: "16213E")
    
    // Accents
    let primaryAccent = Color(hex: "9D4EDD")      // Фиолетовый
    let secondaryAccent = Color(hex: "7B2CBF")    // Тёмный фиолетовый
    let goldAccent = Color(hex: "FFD700")         // Золотой
    let mysticalBlue = Color(hex: "3D5A80")       // Мистический синий
    
    // Cards
    let cardBackground = Color(hex: "1E1E2E").opacity(0.8)
    let cardBorder = Color(hex: "9D4EDD").opacity(0.3)
    
    // Text
    let textPrimary = Color.white
    let textSecondary = Color.white.opacity(0.7)
    let textMuted = Color.white.opacity(0.5)
    
    // Status
    let success = Color.green
    let warning = Color.orange
    let error = Color.red
    
    // Glassmorphism
    let glassBackground = Color.white.opacity(0.1)
    let glassBorder = Color.white.opacity(0.2)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
