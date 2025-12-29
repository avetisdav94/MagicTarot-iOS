//
//  GlassCard.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import SwiftUI

struct GlassCard<Content: View> : View {
    let content: Content
    let cornerRadius: CGFloat
    var padding: CGFloat
    var opacity: Double
    
    init(
        cornerRadius: CGFloat =  AppCornerRadius.large,
        padding: CGFloat = AppSpacing.md,
        opacity: Double = 0.1,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
                self.cornerRadius = cornerRadius
                self.padding = padding
                self.opacity = opacity
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.white.opacity(opacity))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
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
