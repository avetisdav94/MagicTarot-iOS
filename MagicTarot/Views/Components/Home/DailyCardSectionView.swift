//
//  DailyCardSectionView.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import SwiftUI

struct DailyCardSectionView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    @Binding var showCardPicker: Bool
    @Binding var showDailyCardSheet: Bool
    
    var body: some View {
        Button {
            if viewModel.dailyCard != nil {
                showDailyCardSheet = true
            }else {
                showCardPicker = true
            }
        } label: {
            GlassCard {
                HStack(spacing: AppSpacing.md) {
                    ZStack {
                        if let dailyCard = viewModel.dailyCard {
                            TarotCardView(
                                card: dailyCard.card,
                                size: CGSize(width: 60, height: 105),
//                                isReversed: dailyCard.isReversed,
                                showName: false
                            )
                        } else {
                            CardBackView(size: CGSize(width: 60, height: 105), isGlowing: true)
                                                            .overlay(
                                                                Image(systemName: "plus")
                                                                    .font(.title)
                                                                    .foregroundStyle(.white)
                                                            )
                        }
                    }
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        HStack {
                            Text("card_of_the_day_title")
                                .font(AppFont.headline())
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if(viewModel.dailyCard == nil) {
                                Text("choose_card_of_the_day")
                                    .font(AppFont.caption(10))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal,8)
                                    .padding(.vertical, 4)
                                    .background(Color.theme.primaryAccent)
                                    .clipShape(Capsule())
                            }
                        }
                        if let dailyCard = viewModel.dailyCard {
                            Text(dailyCard.card.name)
                                .font(AppFont.body())
                                .foregroundStyle(Color.theme.goldAccent)
                            Text("tap_to_select")
                                .font(AppFont.caption())
                                .foregroundStyle(Color.theme.textMuted)
                        } else {
                            Text("select_your_card_that_fell_out")
                                .font(AppFont.body(14))
                                .foregroundStyle(Color.theme.textSecondary)
                        }
                    }
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.theme.textMuted)
                }
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, AppSpacing.md)
    }
}

