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
    @State var numTokens = 2
    @State var power = 3
    @State var toughness = 3
    @State var tokenName = "Goblin"
    
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
}
