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
        @Published var showAddTokenMenu: Bool = false
        
        func resetBoard() {
            tokens = Array()
        }
        
        func toggleAddTokenMenu() {
            showAddTokenMenu = !showAddTokenMenu
        }
    }
}
