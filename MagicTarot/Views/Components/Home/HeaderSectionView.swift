//
//  HeaderSectionView.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import SwiftUI

struct HeaderSectionView: View {
    
    let greetingText: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Magic Tarot")
                    .font(AppFont.mystical(24))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color.theme.goldAccent],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text(greetingText)
                    .font(AppFont.caption())
                    .foregroundStyle(Color.theme.textMuted)
            }
            Spacer()
            
            CoinsBadge(
                balance: 100,
                size: .medium,
                showPlusButton: true
            )
        }
        .padding(.horizontal,  AppSpacing.md)
        .padding(.top, 60)
    }
}

#Preview {
    HeaderSectionView(greetingText: "Good Morning")
}
