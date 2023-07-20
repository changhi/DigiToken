//
//  TokenViewModel.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/19/23.
//

import Foundation

extension TokenCardView {
    @MainActor class TokenVM: ObservableObject {
        @Published var tapped: Bool
        @Published var rotation: Double
        @Published var numTokens: Int
        @Published var power: Int
        @Published var toughness: Int
        @Published var tokenName: String = "Goblin"
        
        init() {
            self.power = 0
            self.toughness = 0
            self.tokenName = ""
            self.tapped = false
            self.rotation = 0.0
            self.numTokens = 1
        }
        
        func setData(model: TokenModel) {
            self.power = model.power
            self.toughness = model.toughness
            self.tokenName = model.tokenName
        }
        
        func tapToken() {
            tapped = !tapped
            if tapped {
                rotation = 90
            } else {
                rotation = 0
            }
        }
        
        func increaseNumTokens() {
            numTokens += 1
        }
        
        func decreaseNumTokens() {
            numTokens -= 1
        }
    }
}
