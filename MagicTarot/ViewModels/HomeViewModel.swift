//
//  TarotListViewModel.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import Foundation


class HomeViewModel: ObservableObject {
    @Published var cards: [TarotCard] = []
    
    init() {
        loadCards()
    }
    
    func loadCards() {
        self.cards = mockCards
    }
}
