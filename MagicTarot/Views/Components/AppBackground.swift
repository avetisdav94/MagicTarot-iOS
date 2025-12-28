//
//  AppBackground.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.theme.backgroundTop,
                    Color.theme.backgroundMiddle,
                    Color.theme.backgroundBottom
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            //Stars
            StarsOverlay()
        }
        .ignoresSafeArea()
    }
}

struct Star: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let maxOpacity: Double
    let animationDuration: Double
}

struct StarsOverlay: View {
    private let stars: [Star] = (0..<40).map { _ in
        Star(
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 1...3),
            maxOpacity: Double.random(in: 0.5...1.0),
            animationDuration: Double.random(in: 2...5)
        )
    }

    var body: some View {
        GeometryReader { geometry in
            ForEach(stars) { star in
                TwinklingStar(star: star, geometry: geometry)
            }
        }
        .allowsHitTesting(false)
    }
}

struct TwinklingStar: View {
    let star: Star
    let geometry: GeometryProxy
    
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .fill(Color.white)
            // Анимируем прозрачность от 0.1 до maxOpacity
            .opacity(isAnimating ? star.maxOpacity : 0.1)
            .frame(width: star.size, height: star.size)
            .position(
                x: star.x * geometry.size.width,
                y: star.y * geometry.size.height
            )
            .onAppear {
                // Запускаем бесконечную анимацию
                withAnimation(
                    Animation
                        .easeInOut(duration: star.animationDuration)
                        .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    AppBackground()
}
