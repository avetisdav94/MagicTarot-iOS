
import SwiftUI

struct DailyCardSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLoadingMessage = false
    @State private var message: String = ""
    @State private var showMessage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                ScrollView {
                    VStack(spacing: AppSpacing.xl) {
                        // Header
                        Text("🌅 Karta Dnia")
                            .font(AppFont.headline(24))
                            .foregroundStyle(.white)
                            .padding(.top, AppSpacing.lg)
                        
                        // Card
                        if let dailyCard = viewModel.dailyCard {
                            VStack(spacing: AppSpacing.lg) {
                                TarotCardView(
                                    card: dailyCard.card,
                                    size: CardDimensions.extraLarge,
                                    isReversed: dailyCard.isReversed,
                                    showName: true
                                )
                                
                                // Message
                                if let savedMessage = dailyCard.message {
                                    InterpretationView(
                                        interpretation: savedMessage,
                                        isStreaming: false
                                    )
                                } else if !showMessage {
                                    MagicButton(
                                        "Otrzymaj przesłanie",
                                        icon: "sparkles",
                                        style: .primary,
                                        isLoading: isLoadingMessage
                                    ) {
                                        Task { await loadMessage() }
                                    }
                                    .padding(.horizontal, AppSpacing.lg)
                                } else {
                                    InterpretationView(
                                        interpretation: message,
                                        isStreaming: isLoadingMessage
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.theme.textMuted)
                    }
                }
            }
        }
    }
    
    private func loadMessage() async {
        isLoadingMessage = true
        showMessage = true
        
        do {
            message = try await viewModel.getDailyCardMessage()
        } catch {
            message = "Błąd połączenia."
        }
        
        isLoadingMessage = false
    }
}
