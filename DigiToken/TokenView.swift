//
//  TokenView.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/12/23.
//

import Foundation
import SwiftUI

struct TokenCardView: View {
    @StateObject var vm = TokenVM()
    var tokenWidth: CGFloat = 100
    var tokenHeight: CGFloat = 140
    
    init(model: TokenModel) {
        self.vm.setData(model: model)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                tapOverlay(width: tokenWidth, height: tokenHeight)
                    .onTapGesture(count: 2, perform: vm.tapToken)
                    .onTapGesture(count: 1, perform: vm.increaseNumTokens)
                tapOverlay(width: tokenWidth, height: tokenHeight)
                    .onTapGesture(count: 2, perform: vm.tapToken)
                    .onTapGesture(count: 1, perform: vm.decreaseNumTokens)
            }.zIndex(1)
            HStack(spacing: 5) {
                if vm.tapped {
                    Text("\(vm.power * vm.numTokens)/\(vm.toughness * vm.numTokens)")
                        .rotationEffect(.degrees(270))
                }
                VStack {
                    HStack {
                        Text("\(vm.numTokens)")
                        Spacer()
                    }.padding([.leading, .top], 10)
                    Spacer()
                    HStack {
                        Text(vm.tokenName)
                        Text("\(vm.power)/\(vm.toughness)")
                    }.padding([.bottom], 10)
                }.frame(width: tokenWidth, height: tokenHeight, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(15)
            }.rotationEffect(.degrees(vm.rotation))
        }
    }
    
    struct tapOverlay: View {
        var width: CGFloat
        var height: CGFloat
        
        init(width: CGFloat, height: CGFloat) {
            self.width = width
            self.height = height
        }
        
        var body: some View {
            Color.clear
                .contentShape(Rectangle())
                .frame(width: width, height: height)
        }
    }
}

struct TokenModel: Hashable {
    static var uid = 0
    var power: Int
    var toughness: Int
    var tokenName: String
    var numTokens: Int
    var id: Int
    
    init(power: Int = 1, toughness: Int = 1, tokenName: String = "") {
        self.power = power
        self.toughness = toughness
        self.tokenName = tokenName
        self.numTokens = 1
        self.id = TokenModel.generateId()
    }
    
    static func generateId() -> Int {
      uid += 1
      return uid
    }
    static func == (lhs: TokenModel, rhs: TokenModel) -> Bool {
        return lhs.id == rhs.id
    }
}
