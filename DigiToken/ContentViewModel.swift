//
//  ContentViewModel.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/13/23.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var tokens: Array<TokenModel> = Array()
        @Published var tokenCount = 0
        @Published var rowSize1 = 0
        @Published var showAddTokenMenu: Bool = false
        
        func addToken() {
            tokenCount += 1
        }
        
        func toggleAddTokenMenu() {
            showAddTokenMenu = !showAddTokenMenu
        }
    }
}
