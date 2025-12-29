//
//  TarotCardView.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import SwiftUI

struct TarotCardView: View {
    let card: TarotCard
    let size: CGSize
    var isReversed: Bool = false
    var showName: Bool = true
    
    
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            if card.imageName.isEmpty {
                cardPlaceholder
            } else {
                Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped() // Обрезаем, если картинка не влезает в пропорции
            }
            RoundedRectangle(cornerRadius: AppCornerRadius.card)
                .stroke(Color.theme.goldAccent.opacity(0.3), lineWidth: 1)
        }
        .cornerRadius(AppCornerRadius.card)
                   // Тень для объема
                   .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                   // Переворот, если карта перевернута (Reversed meaning)
                   .rotationEffect(isReversed ? .degrees(180) : .degrees(0))
                   
                   // НАЗВАНИЕ КАРТЫ (ЕСЛИ НУЖНО)
                   if showName {
                       Text(card.namePl) // Используем польское имя
                           .font(AppFont.caption(12))
                           .foregroundStyle(.white)
                           .multilineTextAlignment(.center)
                           .lineLimit(2)
                           .frame(width: size.width) // Чтобы текст не разъезжался
                   }
    }
    
    
    @ViewBuilder
    private var cardImage: some View {
        if card.imageName.isEmpty {
            
        }
    }
    
    private var cardPlaceholder: some View {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: "2D1B69"),
                        Color(hex: "1A0F3C")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack(spacing: 8) {
                    Text("\(card.id)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.theme.goldAccent)
                    
                    Text(card.name)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                }
            }
        }
}
