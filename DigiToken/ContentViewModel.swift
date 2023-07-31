//
//  ContentViewModel.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/13/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var tokens: Array<TokenViewModel> = Array()
    @Published var showAddTokenMenu: Bool = false
    
    func resetBoard() {
        tokens = Array<TokenViewModel>()
        TokenViewModel.resetUID()
    }
    
    func toggleAddTokenMenu() {
        showAddTokenMenu = !showAddTokenMenu
    }
    
    func removeToken(id: Int) {
        for (i, token) in tokens.enumerated() {
            if token.id == id {
                tokens.remove(at: i)
            }
        }
    }
}
