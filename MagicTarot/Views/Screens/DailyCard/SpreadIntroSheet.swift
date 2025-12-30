import SwiftUI

struct SpreadIntroSheet: View {
    // 1. Используем String(localized:), чтобы Xcode увидел ключи
    let title: String = String(localized: "spread_intro_title")
    let description: String = String(localized: "spread_intro_description")
    let cost: Int = 10
    
    // Действия
    var onStart: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.theme.backgroundMiddle.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Картинка
                ZStack {
                    Circle()
                        .fill(Color.theme.primaryAccent.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .blur(radius: 20)
                    
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.theme.goldAccent)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                
                // 2. Заголовок и Описание
                VStack(spacing: AppSpacing.md) {
                    Text(title) // Теперь тут будет переведенный текст
                        .font(AppFont.mystical(32))
                        .foregroundStyle(.white)
                    
                    Text(description) // И тут тоже
                        .font(AppFont.body(16))
                        .foregroundStyle(Color.theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // 3. Цена и Кнопка
                VStack(spacing: AppSpacing.md) {
                    HStack {
                        // Используем ключ прямо в Text
                        Text(String(localized: "cost_label"))
                            .font(AppFont.body())
                            .foregroundStyle(Color.theme.textMuted)
                        
                        CoinsBadge(balance: cost, size: .medium, showPlusButton: false)
                    }
                    
                    MagicButton(
                        String(localized: "begin_spread_button"), // КЛЮЧ
                        icon: "sparkles",
                        style: .gold
                    ) {
                        onStart()
                    }
                    
                    Button(String(localized: "cancel_button")) { // КЛЮЧ
                        onCancel()
                    }
                    .font(AppFont.caption())
                    .foregroundStyle(Color.theme.textMuted)
                    .padding(.top, 8)
                }
                .padding(AppSpacing.xl)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous).padding(.bottom, -100))
                        .ignoresSafeArea()
                )
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
