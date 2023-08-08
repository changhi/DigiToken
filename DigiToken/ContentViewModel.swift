//
//  ContentViewModel.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/13/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var tokens: Array<TokenViewModel>
    @Published var showAddTokenMenu: Bool = false
    
    init() {
        self.tokens = Array()
        self.showAddTokenMenu = false
        for _ in 0..<4 {
            tokens.append(TokenViewModel())
        }
    }
    
    func resetBoard() {
        tokens = Array<TokenViewModel>()
        TokenViewModel.resetUID()
    }
    
    func toggleAddTokenMenu() {
        showAddTokenMenu = !showAddTokenMenu
    }
    
    func createToken(_ tokenName: String, _ power: Int, _ toughness: Int) {
        for i in 0..<tokens.count {
            if !tokens[i].show {
                tokens[i].power = power
                tokens[i].toughness = toughness
                tokens[i].tokenName = tokenName
                tokens[i].show = true
                break
            }
        }
        
    }
    
    func change() {
        self.objectWillChange.send()
    }
}
