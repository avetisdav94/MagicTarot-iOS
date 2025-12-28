//
//  TarotListView.swift
//  MagicTarot
//
//  Created by developer on 28/12/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                ScrollView(showsIndicators: false) {
                    VStack {
                        //MARK: Header Section
                        HeaderSectionView()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
