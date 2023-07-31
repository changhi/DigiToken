//
//  TokenView.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/12/23.
//

import Foundation
import SwiftUI
import Combine

struct TokenCardView: View {
    @Binding var model: TokenViewModel
    
    var body: some View {
        ZStack {
            HStack(spacing: 5) {
                if model.rotation == 90 {
                    Text("\(model.power * model.numTokens)/\(model.toughness * model.numTokens)")
                        .rotationEffect(.degrees(270))
                }
                VStack {
                    HStack {
                        Text("\(model.numTokens)")
                        Spacer()
                    }.padding([.leading, .top], 10)
                    Spacer()
                    HStack {
                        Text(model.tokenName)
                        Text("\(model.power)/\(model.toughness)")
                    }.padding([.bottom], 10)
                }.frame(width: 120, height: 160, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
        }.rotationEffect(.degrees(model.rotation))
    }
    
}

class TokenViewModel: ObservableObject, Hashable {
    static private var uid: Int = 0
    var id: Int
    var tokenName: String
    var rotation: Double
    var power: Int
    var toughness: Int
    var numTokens: Int
    
    init(_ tokenName: String, _ power: Int, _ toughness: Int) {
        self.id = TokenViewModel.generateId()
        self.tokenName = tokenName
        self.rotation = 0.0
        self.power = power
        self.toughness = toughness
        self.numTokens = 1
    }
    
    static func generateId() -> Int {
          uid += 1
          return uid
    }
    
    static func == (lhs: TokenViewModel, rhs: TokenViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    static func resetUID() {
        uid = 0;
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
