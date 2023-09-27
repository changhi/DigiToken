//
//  ContentViewModel.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/13/23.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var tokens: Array<TokenViewModel>
    @Published var showAddTokenMenu: Bool = false
    @Published var tmp: CardInfo?
    
    let service: ScryfallCardFetcherAPIServices
    
    init(service: ScryfallCardFetcherAPIServices = ScryfallTokenFetcherServices.shared) {
        self.tokens = Array()
        self.showAddTokenMenu = false
        self.service = service
        for _ in 0..<4 {
            tokens.append(TokenViewModel(Environment(\.scryFallService).wrappedValue))
        }
    }
    
    func resetBoard() {
        tokens = Array<TokenViewModel>()
        TokenViewModel.resetUID()
        for _ in 0..<4 {
            tokens.append(TokenViewModel(Environment(\.scryFallService).wrappedValue))
        }
    }
    
    func toggleAddTokenMenu() {
        showAddTokenMenu = !showAddTokenMenu
    }
    
    func toggleCounters() {
        for token in tokens {
            token.addCounters = !token.addCounters
        }
    }
    
    func createToken(_ tokenName: String, _ power: Int, _ toughness: Int) {
        var selected = 0
        for i in 0..<tokens.count {
            if !tokens[i].show {
                tokens[i].power = power
                tokens[i].toughness = toughness
                tokens[i].tokenName = tokenName
                tokens[i].show = true
                selected = i
                break
            }
        }
        service.getCardImageURL(cardName: tokenName).assign(to: &tokens[selected].$imageURL)
    }
    
    func change() {
        self.objectWillChange.send()
    }
}
