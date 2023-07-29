//
//  TokenView.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/12/23.
//

import Foundation
import SwiftUI

struct TokenCardView: View {
    @Binding var model: TokenModel
    
    var body: some View {
        ZStack {
//            VStack(spacing: 0) {
//                tapOverlay(100, 140, true, numTokens: self.$numTokens, rotation: self.$rotation)
//                tapOverlay(100, 140, false, numTokens: self.$numTokens, rotation: self.$rotation)
//            }.zIndex(1)
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
    
//    struct tapOverlay: View {
//        var width: CGFloat
//        var height: CGFloat
//        var increase: Bool
//        @Binding var numTokens: Int
//        @Binding var rotation: Double
//
//        init(_ width: CGFloat, _ height: CGFloat, _ increase: Bool, numTokens: Binding<Int>, rotation: Binding<Double>) {
//            self.width = width
//            self.height = height / 2
//            self._numTokens = numTokens
//            self._rotation = rotation
//            self.increase = increase
//        }
//
//        var body: some View {
//            Color.clear
//                .contentShape(Rectangle())
//                .frame(width: width, height: height)
//                .onTapGesture(count: 2) {
//                    if rotation == 90 {
//                        rotation = 0
//                    } else {
//                        rotation = 90
//                    }
//                }.onTapGesture {
//                    if increase {
//                        numTokens += 1
//                    }
//                    else {
//                        numTokens -= 1
//                    }
//                }
//        }
//    }
}

struct TokenModel: Hashable {
    static var uid = 0
    var power: Int
    var toughness: Int
    var tokenName: String
    var numTokens: Int
    var rotation: Double
    var id: Int
    
    init(power: Int = 1, toughness: Int = 1, tokenName: String = "") {
        self.power = power
        self.toughness = toughness
        self.tokenName = tokenName
        self.numTokens = 1
        self.id = TokenModel.generateId()
        self.rotation = 0
    }
    
    static func generateId() -> Int {
      uid += 1
      return uid
    }
    static func == (lhs: TokenModel, rhs: TokenModel) -> Bool {
        return lhs.id == rhs.id
    }
}
