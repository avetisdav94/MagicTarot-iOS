import SwiftUI

struct StreamingTextView: View {
    @Binding var text: String
    var isStreaming: Bool
    
    // Состояние для анимации точек
    @State private var dotPhase = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Текст-заглушка (например "Nawiązywanie połączenia...")
            Text(text)
                .font(AppFont.body())
                .foregroundStyle(.white.opacity(0.7))
            
            // Анимированные точки
            if isStreaming {
                HStack(spacing: 6) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.theme.goldAccent) // Или .white
                            .frame(width: 8, height: 8)
                            .opacity(dotOpacity(for: index))
                            .scaleEffect(dotScale(for: index))
                    }
                }
                .onAppear {
                    // Запускаем бесконечную анимацию
                    withAnimation(.easeInOut(duration: 0.8).repeatForever()) {
                        dotPhase = 3
                    }
                }
            }
        }
    }
    
    // Вычисляем прозрачность
    private func dotOpacity(for index: Int) -> Double {
        // Делаем "волну" прозрачности
        // Если фаза 3, то все точки видны, но с задержкой анимации это создаст эффект
        return 1.0
    }
    
    // Вычисляем размер (пульсацию)
    private func dotScale(for index: Int) -> CGFloat {
        let phaseValue = Double(dotPhase)
        // Простая математика для сдвига фазы
        // (Это упрощенная версия, чтобы не писать сложный TimelineView)
        return (phaseValue > Double(index)) ? 1.0 : 0.5
    }
}

#Preview {
    ZStack {
        Color.black
        StreamingTextView(text: .constant("Waiting for AI..."), isStreaming: true)
            .padding()
    }
}
