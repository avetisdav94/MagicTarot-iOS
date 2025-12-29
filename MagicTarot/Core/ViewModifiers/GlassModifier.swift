import SwiftUI

// 1. Описываем рецепт "Стекла"
struct GlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial) // 1. Размытие (Blur)
            .background(Color.theme.glassBackground) // 2. Твой цвет из темы!
            .cornerRadius(AppCornerRadius.large) // 3. Закругление
            .overlay(
                // 4. Светящаяся рамка
                RoundedRectangle(cornerRadius: AppCornerRadius.large)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.theme.glassBorder, // Используем твой border
                                Color.theme.glassBorder.opacity(0.5),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

// 2. Создаем функцию-расширение, чтобы использовать .glassBackground()
extension View {
    func glassBackground() -> some View {
        self.modifier(GlassModifier())
    }
}
