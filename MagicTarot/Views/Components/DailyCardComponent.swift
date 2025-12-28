//
//  DailyCardComponent.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import SwiftUI

struct DailyCardComponent: View {
    let card: TarotCard
    
    var body: some View {
//        NavigationLink() {
        HStack {
            Image(card.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(.orange)
            VStack(alignment: .leading) {
                Text("Choose your card")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
//        }
    }
}

#Preview {
    DailyCardComponent(card: mockCards[0])
}
