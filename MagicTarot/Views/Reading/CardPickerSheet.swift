import SwiftUI

struct CardPickerSheet: View {
    // Входящие данные
    let allCards: [TarotCard]
    let alreadySelected: [UUID] // Исправлено: UUID вместо Int
    let onSelect: (TarotCard, Bool) -> Void
    
    // Закрытие окна
    @Environment(\.dismiss) private var dismiss
    
    // Состояние
    @State private var searchText = ""
    @State private var selectedArcana: ArcanaFilter = .all
    @State private var selectedCard: TarotCard?
    @State private var isReversed = false
    @State private var showConfirmation = false
    
    // Фильтр для табов
    enum ArcanaFilter: String, CaseIterable {
        case all = "Wszystkie"
        case major = "Wielkie Arkana"
        case wands = "Buławy"
        case cups = "Kielichy"
        case swords = "Miecze"
        case pentacles = "Pentakle"
    }
    
    // Логика фильтрации
    var filteredCards: [TarotCard] {
        var cards = allCards
        
        // 1. Фильтр по типу
        switch selectedArcana {
        case .all:
            break
        case .major:
            cards = cards.filter { $0.arcana == .major }
        case .wands:
            cards = cards.filter { $0.suit == .wands }
        case .cups:
            cards = cards.filter { $0.suit == .cups }
        case .swords:
            cards = cards.filter { $0.suit == .swords }
        case .pentacles:
            cards = cards.filter { $0.suit == .pentacles }
        }
        
        // 2. Фильтр по поиску (ищем и на PL, и на EN)
        if !searchText.isEmpty {
            cards = cards.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.namePl.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return cards
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.backgroundMiddle.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    searchBar
                    filterTabs
                    cardsGrid
                }
            }
            .navigationTitle("Wybierz kartę")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Anuluj") {
                        dismiss() // Исправлено: теперь работает
                    }
                    .foregroundStyle(Color.theme.textMuted)
                }
            }
            // Лист подтверждения выбора
            .sheet(isPresented: $showConfirmation) {
                if let card = selectedCard {
                    CardConfirmationSheet(
                        card: card,
                        isReversed: $isReversed,
                        onConfirm: {
                            print("✅ Confirmed card \(card.namePl), reversed = \(isReversed)")
                            onSelect(card, isReversed)
                            showConfirmation = false
                            dismiss() // Закрываем весь пикер
                        }
                    )
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                }
            }
        }
    }
    
    // MARK: - Search Bar Component
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.theme.textMuted)
            
            TextField("Szukaj karty...", text: $searchText)
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.theme.glassBackground)
        .cornerRadius(AppCornerRadius.medium)
        .padding()
    }
    
    // MARK: - Filter Tabs Component
    private var filterTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(ArcanaFilter.allCases, id: \.self) { filter in
                    Button {
                        withAnimation {
                            selectedArcana = filter
                        }
                    } label: {
                        Text(filter.rawValue)
                            .font(AppFont.caption())
                            .foregroundStyle(selectedArcana == filter ? .white : Color.theme.textMuted)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(selectedArcana == filter
                                          ? Color.theme.primaryAccent
                                          : Color.theme.glassBackground)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Grid Component
    private var cardsGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 100), spacing: AppSpacing.sm)
            ], spacing: AppSpacing.sm) {
                ForEach(filteredCards) { card in
                    CardGridItem(
                        card: card,
                        isDisabled: alreadySelected.contains(card.id) // Сравниваем UUID
                    ) {
                        selectedCard = card
                        isReversed = false // Сбрасываем переворот при новом выборе
                        showConfirmation = true
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Helper Views

struct CardGridItem: View {
    let card: TarotCard
    let isDisabled: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                // Имитация карты
                RoundedRectangle(cornerRadius: AppCornerRadius.small)
                    .fill(
                        LinearGradient(
                            colors: [Color.theme.primaryAccent.opacity(0.3), Color.theme.backgroundMiddle],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 130)
                    .overlay(
                        VStack(spacing: 4) {
                            // Показываем ранг карты (номер) вместо ID
                            Text("\(card.rank)")
                                .font(AppFont.headline())
                                .foregroundStyle(Color.theme.goldAccent)
                            
                            // Звездочка для Старших Арканов
                            if card.arcana == .major {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.theme.goldAccent.opacity(0.5))
                            }
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.small)
                            .stroke(Color.theme.glassBorder, lineWidth: 1)
                    )
                
                // Название на польском
                Text(card.namePl)
                    .font(AppFont.caption(11))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .opacity(isDisabled ? 0.4 : 1)
        }
        .disabled(isDisabled)
    }
}

struct CardConfirmationSheet: View {
    let card: TarotCard
    @Binding var isReversed: Bool
    let onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.theme.backgroundMiddle.ignoresSafeArea()
            
            VStack(spacing: AppSpacing.lg) {
                // Card Preview
                VStack(spacing: AppSpacing.sm) {
                    RoundedRectangle(cornerRadius: AppCornerRadius.card)
                        .fill(Color.theme.glassBackground)
                        .frame(width: 120, height: 200)
                        .overlay(
                            VStack {
                                Text("\(card.rank)") // Ранг
                                    .font(AppFont.headline(24))
                                    .foregroundStyle(Color.theme.goldAccent)
                                
                                Text(card.namePl) // Имя PL
                                    .font(AppFont.body())
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 4)
                            }
                        )
                        // Анимация переворота
                        .rotationEffect(.degrees(isReversed ? 180 : 0))
                        .animation(.spring(), value: isReversed)
                    
                    Text(card.namePl)
                        .font(AppFont.headline())
                        .foregroundStyle(.white)
                }
                
                // Reversed toggle
                VStack(spacing: AppSpacing.sm) {
                    Text("Czy karta jest odwrócona?")
                        .font(AppFont.body())
                        .foregroundStyle(Color.theme.textSecondary)
                    
                    HStack(spacing: AppSpacing.lg) {
                        ReversedButton(
                            title: "Prosta",
                            icon: "arrow.up",
                            isSelected: !isReversed
                        ) {
                            isReversed = false
                        }
                        
                        ReversedButton(
                            title: "Odwrócona",
                            icon: "arrow.down",
                            isSelected: isReversed
                        ) {
                            isReversed = true
                        }
                    }
                }
                
                // Keywords Preview
                HStack(spacing: 6) {
                    ForEach(card.keyWords.prefix(3), id: \.self) { keyword in
                        Text(keyword)
                            .font(AppFont.caption())
                            .foregroundStyle(Color.theme.primaryAccent)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.theme.primaryAccent.opacity(0.2))
                            )
                    }
                }
                
                Spacer()
                
                // Confirm Button
                MagicButton("Potwierdź wybór", icon: "checkmark", style: .primary) {
                    onConfirm()
                }
                .padding(.horizontal)
                .padding(.bottom, AppSpacing.lg)
            }
            .padding()
        }
    }
}

struct ReversedButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                
                Text(title)
                    .font(AppFont.caption())
            }
            .foregroundStyle(isSelected ? .white : Color.theme.textMuted)
            .frame(width: 110, height: 70)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(isSelected ? Color.theme.primaryAccent : Color.theme.glassBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(isSelected ? Color.theme.goldAccent.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    CardPickerSheet(
        allCards: mockCards,
        alreadySelected: [],
        onSelect: { card, reversed in
            print("Selected: \(card.namePl) (Reversed: \(reversed))")
        }
    )
}
