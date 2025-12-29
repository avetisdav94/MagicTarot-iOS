
import SwiftUI

struct CardBackView: View {
    let size: CGSize
    var isGlowing: Bool = false
    
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Основной фон
            RoundedRectangle(cornerRadius: AppCornerRadius.card)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "2D1B69"),
                            Color(hex: "1A0F3C")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Паттерн
            GeometryReader { geometry in
                ZStack {
                    // Центральный символ
                    Image(systemName: "star.fill")
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.3))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.theme.goldAccent, Color.theme.goldAccent.opacity(0.5)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .rotationEffect(.degrees(rotationAngle))
                    
                    // Декоративный круг
                    Circle()
                        .stroke(
                            Color.theme.goldAccent.opacity(0.3),
                            lineWidth: 1
                        )
                        .frame(width: min(geometry.size.width, geometry.size.height) * 0.6)
                    
                    // Внешний круг
                    Circle()
                        .stroke(
                            Color.theme.goldAccent.opacity(0.15),
                            lineWidth: 1
                        )
                        .frame(width: min(geometry.size.width, geometry.size.height) * 0.8)
                    
                    // Угловые символы
                    ForEach(0..<4) { index in
                        Image(systemName: "moon.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.theme.goldAccent.opacity(0.4))
                            .position(cornerPosition(for: index, in: geometry.size))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Рамка
            RoundedRectangle(cornerRadius: AppCornerRadius.card)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.theme.goldAccent.opacity(0.6),
                            Color.theme.goldAccent.opacity(0.2),
                            Color.theme.goldAccent.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        }
        .frame(width: size.width, height: size.height)
        .shadow(
            color: isGlowing ? Color.theme.primaryAccent.opacity(0.5) : .black.opacity(0.3),
            radius: isGlowing ? 15 : 8,
            x: 0,
            y: 4
        )
        .onAppear {
            if isGlowing {
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
        }
    }
    
    private func cornerPosition(for index: Int, in size: CGSize) -> CGPoint {
        let padding: CGFloat = 20
        switch index {
        case 0: return CGPoint(x: padding, y: padding)
        case 1: return CGPoint(x: size.width - padding, y: padding)
        case 2: return CGPoint(x: padding, y: size.height - padding)
        case 3: return CGPoint(x: size.width - padding, y: size.height - padding)
        default: return .zero
        }
    }
}

#Preview {
    ZStack {
        Color.theme.backgroundMiddle.ignoresSafeArea()
        
        HStack(spacing: 20) {
            CardBackView(size: CardDimensions.medium)
            CardBackView(size: CardDimensions.medium, isGlowing: true)
        }
    }
}
