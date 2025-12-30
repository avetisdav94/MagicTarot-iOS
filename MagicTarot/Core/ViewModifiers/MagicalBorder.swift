import SwiftUI

struct MagicalBorder: ViewModifier {
    @State private var rotation: Double = 0
    
    var lineWidth: CGFloat = 2
    var cornerRadius: CGFloat = AppCornerRadius.medium
    
    private let gradientColors = [
        Color.theme.goldAccent,
        Color.theme.primaryAccent.opacity(0.2), // Более прозрачный
        Color.theme.goldAccent,
        Color.theme.primaryAccent.opacity(0.2),
        Color.theme.goldAccent
    ]
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    // 1. Вращающийся Градиент (на фоне)
                    AngularGradient(
                        gradient: Gradient(colors: gradientColors),
                        center: .center
                    )
                    // Увеличиваем, чтобы градиент покрывал всю карту при любом повороте
                    // Это решает проблему "квадрата"
                    .scaleEffect(2.0)
                    .rotationEffect(.degrees(rotation))
                    .mask(
                        // 2. Вырезаем из градиента только рамку
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(lineWidth: lineWidth)
                    )
                }
            )
            .onAppear {
                // Запускаем анимацию только если она еще не запущена (защита от глюков)
                if rotation == 0 {
                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
            }
    }
}

extension View {
    func magicalBorder(lineWidth: CGFloat = 2, cornerRadius: CGFloat = AppCornerRadius.medium) -> some View {
        self.modifier(MagicalBorder(lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}
