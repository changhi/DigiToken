//
//  TokenView.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/12/23.
//

import Foundation
import SwiftUI

struct TokenCardView: View {
    @State var tapped = false
    @State var rotation = 0.0
    @State var numTokens = 1
    @State var power: Int
    @State var toughness: Int
    @State var tokenName: String
    
    init(power: Int = 1, toughness: Int = 1, tokenName: String = "") {
        self.power = power
        self.toughness = toughness
        self.tokenName = tokenName
    }
    
    init(model: TokenModel) {
        self.power = model.power
        self.toughness = model.toughness
        self.tokenName = model.tokenName
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 5) {
                if tapped {
                    Text("\(power * numTokens)/\(toughness * numTokens)")
                        .rotationEffect(.degrees(270))
                }
                VStack {
                    HStack {
                        Text("\(numTokens)")
                        Spacer()
                    }.padding([.leading, .top], 10)
                    Spacer()
                    HStack {
                        Text(tokenName)
                        Text("\(power)/\(toughness)")
                    }.padding([.bottom], 10)
                }.frame(width: 100, height: 140, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(15)
            }.rotationEffect(.degrees(rotation))
            .onTapGesture(count: 2) {
                tapped = !tapped
                if tapped {
                    rotation = 90
                } else {
                    rotation = 0
                }
            }
        }
    }
    
    func SetTokenStats(_ tokenName: String, _ power: Int, _ toughness: Int) {
        self.tokenName = tokenName
        self.power = power
        self.toughness = toughness
    }
}

struct TokenModel: Hashable {
    var power: Int
    var toughness: Int
    var tokenName: String
    var numTokens: Int
    
    init(power: Int = 1, toughness: Int = 1, tokenName: String = "") {
        self.power = power
        self.toughness = toughness
        self.tokenName = tokenName
        self.numTokens = 1
    }
}
