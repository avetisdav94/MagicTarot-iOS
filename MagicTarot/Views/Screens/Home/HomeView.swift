//
//  TarotListView.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var showDailyCardSheet = false
    @State private var showCardPicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.xl) {
                        
                        //MARK: Header Section
                        HeaderSectionView(greetingText: viewModel.greeting)
                        
                        //MARK: Daily Card Section
                        DailyCardSectionView(
                            viewModel: viewModel,
                            showCardPicker: $showCardPicker, showDailyCardSheet: $showDailyCardSheet
                        )
                    }
                    .padding(.bottom, 100)
                }
                .toolbar(.hidden)
            }
            .sheet(isPresented: $showDailyCardSheet) {
                if let _ = viewModel.dailyCard {
                    DailyCardSheet(viewModel: viewModel)
                        .presentationDetents([.large])
                }else {
                    Text("choose_card_of_the_day")
                }
            }
            .sheet(isPresented: $showCardPicker) {
                            CardPickerSheet(
                                    allCards: viewModel.cards, // Скорее всего у тебя массив называется 'cards', а не 'allCards'
                                    alreadySelected: [],
                                    onSelect: { card, isReversed in
                                        // Вызываем логику выбора
                                        viewModel.selectDailyCard(card: card, isReversed: isReversed)
                                        // Закрываем пикер, открываем просмотр
                                        showCardPicker = false
                                        // Небольшая задержка для красоты анимации смены листов
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            showDailyCardSheet = true
                                        }
                                    }
                                )
            }
            
        }
    }
}

#Preview {
    HomeView()
}
