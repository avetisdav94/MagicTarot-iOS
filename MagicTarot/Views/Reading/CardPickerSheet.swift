import SwiftUI

struct CardPickerSheet: View {
    // MARK: - Properties
    let allCards: [TarotCard]
    let alreadySelected: [UUID]
    let onSelect: (TarotCard, Bool) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    @State private var searchText = ""
    @State private var selectedArcana: ArcanaFilter = .all
    @State private var selectedCard: TarotCard?
    @State private var isReversed = false
    
    // MARK: - Filter Enum
    enum ArcanaFilter: String, CaseIterable {
        case all = "filter_all"
        case major = "filter_major"
        case wands = "filter_wands"
        case cups = "filter_cups"
        case swords = "filter_swords"
        case pentacles = "filter_pentacles"
        
        var localizedName: String {
            String(localized: String.LocalizationValue(rawValue))
        }
    }
    
    // MARK: - Filtering Logic
    var filteredCards: [TarotCard] {
        var cards = allCards
        
        // 1. Фильтр по категории
        switch selectedArcana {
        case .all: break
        case .major: cards = cards.filter { $0.arcana == .major }
        case .wands: cards = cards.filter { $0.suit == .wands }
        case .cups: cards = cards.filter { $0.suit == .cups }
        case .swords: cards = cards.filter { $0.suit == .swords }
        case .pentacles: cards = cards.filter { $0.suit == .pentacles }
        }
        
        // 2. Поиск
        if !searchText.isEmpty {
            cards = cards.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.namePl.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // 3. Сортировка по рангу
        return cards.sorted { $0.rank < $1.rank }
    }
    
    // MARK: - Body
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
            .navigationTitle(String(localized: "select_card_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(String(localized: "cancel_button")) {
                        dismiss()
                    }
                    .foregroundStyle(Color.theme.textMuted)
                }
            }
            // Окно подтверждения
            .sheet(item: $selectedCard) { card in
                // SwiftUI сам "распаковал" карту, она точно существует здесь
                CardConfirmationSheet(
                    card: card,
                    isReversed: $isReversed,
                    onConfirm: {
                        print("🃏 Selected: \(card.namePl)")
                        onSelect(card, isReversed)
                        selectedCard = nil // Закрываем окно, обнуляя карту
                        dismiss()
                    }
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    // MARK: - Components UI
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.theme.textMuted)
            
            TextField(String(localized: "search_placeholder"), text: $searchText)
                .foregroundStyle(.white)
                .autocorrectionDisabled()
        }
        .padding()
        .background(Color.theme.glassBackground)
        .cornerRadius(AppCornerRadius.medium)
        .padding()
    }
    
    private var filterTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(ArcanaFilter.allCases, id: \.self) { filter in
                    Button {
                        withAnimation { selectedArcana = filter }
                    } label: {
                        Text(filter.localizedName)
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
                            .overlay(
                                Capsule().stroke(Color.theme.glassBorder, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, AppSpacing.sm)
    }
    
    private var cardsGrid: some View {
        ScrollView {
            if filteredCards.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundStyle(Color.theme.textMuted.opacity(0.5))
                        .padding(.top, 50)
                    Text(String(localized: "no_cards_found"))
                        .font(AppFont.body())
                        .foregroundStyle(Color.theme.textMuted)
                }
                .frame(maxWidth: .infinity)
            } else {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 100), spacing: AppSpacing.md)
                ], spacing: AppSpacing.md) {
                    ForEach(filteredCards) { card in
                        CardGridItem(
                            card: card,
                            isDisabled: alreadySelected.contains(card.id)
                        ) {
                        onTap: do {
                                // Вибрация
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                
                                selectedCard = card
                                isReversed = false
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 50)
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

// MARK: - Helper Views

struct CardGridItem: View {
    let card: TarotCard
    let isDisabled: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // 1. Картинка в рамке
                ZStack {
                    if !card.imageName.isEmpty {
                        Image(card.imageName) // Берем из Assets
                            .resizable()
                            .aspectRatio(contentMode: .fit) // Видно целиком
                            .frame(height: 140)
                            // background нужен, чтобы при .fit не было пустых мест по краям рамки
                            .background(Color.theme.backgroundMiddle)
                    } else {
                        fallbackPlaceholder
                    }
                    
                    // Затемнение для выбранных
                    if isDisabled {
                        Color.black.opacity(0.6)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
                .cornerRadius(AppCornerRadius.medium)
                // --- ПРИМЕНЯЕМ МАГИЮ ---
                .if(!isDisabled) { view in
                    view.magicalBorder(lineWidth: 1.5, cornerRadius: AppCornerRadius.medium)
                }
                .if(isDisabled) { view in
                    view.overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                
                // 2. Имя
                Text(card.namePl)
                    .font(AppFont.caption(11))
                    .foregroundStyle(isDisabled ? Color.theme.textMuted : .white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .opacity(isDisabled ? 0.6 : 1)
            .scaleEffect(isDisabled ? 0.95 : 1)
        }
        .disabled(isDisabled)
    }
    
    private var fallbackPlaceholder: some View {
        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
            .fill(Color.theme.backgroundMiddle)
            .frame(height: 140)
            .overlay(
                VStack(spacing: 4) {
                    Text("\(card.rank)")
                        .font(AppFont.headline())
                        .foregroundStyle(Color.theme.goldAccent)
                }
            )
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
                Text(String(localized: "confirm_choice_title"))
                    .font(AppFont.headline(20))
                    .foregroundStyle(.white)
                    .padding(.top, AppSpacing.lg)
                
                // Большая карта
                TarotCardView(
                    card: card,
                    size: CGSize(width: 180, height: 310),
                    isReversed: isReversed,
                    showName: false
                )
                // Тоже добавим магию, но пожирнее
                .shadow(color: Color.theme.goldAccent.opacity(0.2), radius: 20)
                
                Text(card.namePl)
                    .font(AppFont.mystical(28))
                    .foregroundStyle(Color.theme.goldAccent)
                
                HStack(spacing: AppSpacing.lg) {
                    ReversedButton(
                        title: String(localized: "upright"),
                        icon: "arrow.up",
                        isSelected: !isReversed
                    ) { withAnimation { isReversed = false } }
                    
                    ReversedButton(
                        title: String(localized: "reversed"),
                        icon: "arrow.down",
                        isSelected: isReversed
                    ) { withAnimation { isReversed = true } }
                }
                .padding(.vertical)
                
                Spacer()
                
                MagicButton(
                    String(localized: "select_card_button"),
                    icon: "checkmark",
                    style: .primary
                ) {
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
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

// Расширение для условного модификатора (чтобы не дублировать код в GridItem)
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    CardPickerSheet(
        allCards: mockCards,
        alreadySelected: [],
        onSelect: { _, _ in }
    )
}
