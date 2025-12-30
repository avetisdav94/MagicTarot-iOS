// Components/Common/CoinsBadge.swift

import SwiftUI

struct CoinsBadge: View {
    let balance: Int
    var size: BadgeSize = .medium
    var showPlusButton: Bool = false
    var onTap: (() -> Void)?
    
    enum BadgeSize {
        case small, medium, large
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 18
            case .large: return 24
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 20
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 10
            case .large: return 14
            }
        }
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 6) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: size.iconSize))
                    .foregroundStyle(Color.theme.goldAccent)
                
                Text("\(balance)")
                    .font(AppFont.system(size.fontSize, weight: .bold))
                    .foregroundStyle(.white)
                
                if showPlusButton {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: size.iconSize))
                        .foregroundStyle(Color.theme.primaryAccent)
                }
            }
            .padding(.horizontal, size.padding)
            .padding(.vertical, size.padding * 0.6)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                Capsule()
                    .stroke(Color.theme.goldAccent.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.theme.backgroundMiddle.ignoresSafeArea()
        
        VStack(spacing: 20) {
            CoinsBadge(balance: 150, size: .small)
            CoinsBadge(balance: 150, size: .medium, showPlusButton: true)
            CoinsBadge(balance: 1500, size: .large)
        }
    }
}
