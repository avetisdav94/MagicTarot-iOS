//
//  TarotListViewModel.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import Foundation


class HomeViewModel: ObservableObject {
    
    @Published var dailyCard: DailyCardData?
    @Published var cards: [TarotCard] = []
    
    private let tarotService = TarotService()
    
    init() {
        loadCards()
    }
    
    func loadCards() {
        self.cards = mockCards
    }
    func getDailyCardMessage() async throws -> String {
            guard let currentCardData = dailyCard else { return "Wybierz kartę." }
            
            // 2. ВЫЗЫВАЕМ У ЭКЗЕМПЛЯРА (с маленькой буквы tarotService)
            // А не у класса TarotService
            let prediction = try await tarotService.getPrediction(
                for: currentCardData.card.name,
                isReversed: currentCardData.isReversed
            )
            
            // 3. Сохраняем результат, чтобы не грузить снова
            await MainActor.run {
                self.dailyCard = DailyCardData(
                    card: currentCardData.card,
                    isReversed: currentCardData.isReversed,
                    message: prediction,
                    date: currentCardData.date
                )
            }
            
            return prediction
        }
    
    func selectDailyCard(card: TarotCard, isReversed: Bool) {
        self.dailyCard = DailyCardData(
            card: card,
            isReversed: isReversed,
            message: nil, // Сообщения пока нет, его загрузим позже через AI
            date: Date()
        )
    }
    
   
        
        
        //MARK: Greeting
    var greeting: String {
            let hour = Calendar.current.component(.hour, from: Date())
            switch hour {
            case 5..<12: return String(localized: "greeting_morning")
            case 12..<18: return String(localized: "greeting_afternoon")
            case 18..<22: return String(localized: "greeting_evening")
            default: return String(localized: "greeting_night")
            }
        }
    
    struct DailyCardData: Codable {
        let card: TarotCard
        let isReversed: Bool
        let message: String?
        let date: Date
    }
}
