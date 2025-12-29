// Components/Common/MagicButton.swift

import SwiftUI

struct MagicButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let isLoading: Bool
    let action: () -> Void
    
    enum ButtonStyle {
        case primary
        case secondary
        case gold
        case ghost
    }
    
    init(
        _ title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    
                    Text(title)
                        .font(AppFont.system(16, weight: .semibold))
                }
            }
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(borderColor, lineWidth: style == .ghost ? 2 : 0)
            )
            .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
        }
        .disabled(isLoading)
        .scaleEffect(isLoading ? 0.98 : 1)
        .animation(.spring(response: 0.3), value: isLoading)
    }
    
    private var background: some ShapeStyle {
        switch style {
        case .primary:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color.theme.primaryAccent, Color.theme.secondaryAccent],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .secondary:
            return AnyShapeStyle(Color.theme.glassBackground)
        case .gold:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color.theme.goldAccent, Color.theme.goldAccent.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .ghost:
            return AnyShapeStyle(Color.clear)
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .secondary, .ghost:
            return .white
        case .gold:
            return .black
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .ghost:
            return Color.theme.primaryAccent
        default:
            return .clear
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary:
            return Color.theme.primaryAccent.opacity(0.4)
        case .gold:
            return Color.theme.goldAccent.opacity(0.4)
        default:
            return .clear
        }
    }
}

#Preview {
    ZStack {
        Color.theme.backgroundMiddle.ignoresSafeArea()
        
        VStack(spacing: 20) {
            MagicButton("Rozpocznij wróżbę", icon: "sparkles", style: .primary) {}
            MagicButton("Wybierz rozklad", icon: "square.grid.2x2", style: .secondary) {}
            MagicButton("Kup monety", icon: "dollarsign.circle", style: .gold) {}
            MagicButton("Pomiń", style: .ghost) {}
            MagicButton("Ładowanie...", style: .primary, isLoading: true) {}
        }
        .padding()
    }
}
