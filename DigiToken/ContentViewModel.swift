//
//  ContentViewModel.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/13/23.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var tokens: Array<TokenCardView> = Array(repeating: TokenCardView(), count: 3)
    }
}
