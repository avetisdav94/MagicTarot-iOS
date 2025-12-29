
import SwiftUI

// MARK: - Typography

enum AppFont {
    // Основные шрифты
    static func title(_ size: CGFloat = 28) -> Font {
        .custom("Palatino-Bold", size: size)
    }
    
    static func headline(_ size: CGFloat = 20) -> Font {
        .custom("Palatino-Bold", size: size)
    }
    
    static func body(_ size: CGFloat = 16) -> Font {
        .custom("Palatino-Roman", size: size)
    }
    
    static func caption(_ size: CGFloat = 14) -> Font {
        .custom("Palatino-Italic", size: size)
    }
    
    // Мистические шрифты для заголовков
    static func mystical(_ size: CGFloat = 32) -> Font {
        .custom("Zapfino", size: size)
    }
    
    // Системный шрифт для UI элементов
    static func system(_ size: CGFloat = 16, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

// MARK: - Spacing

enum AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius

enum AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 20
    static let extraLarge: CGFloat = 28
    static let card: CGFloat = 16
}

// MARK: - Shadows

struct AppShadow {
    static let small = Shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    static let medium = Shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    static let large = Shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
    static let glow = Shadow(color: Color.theme.primaryAccent.opacity(0.5), radius: 20, x: 0, y: 0)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Card Dimensions

enum CardDimensions {
    static let aspectRatio: CGFloat = 1.75 // Высота / Ширина
    
    static func width(for containerWidth: CGFloat, columns: Int, spacing: CGFloat) -> CGFloat {
        (containerWidth - spacing * CGFloat(columns - 1)) / CGFloat(columns)
    }
    
    static func height(for width: CGFloat) -> CGFloat {
        width * aspectRatio
    }
    
    // Стандартные размеры
    static let small = CGSize(width: 60, height: 105)
    static let medium = CGSize(width: 80, height: 140)
    static let large = CGSize(width: 120, height: 210)
    static let extraLarge = CGSize(width: 160, height: 280)
}

