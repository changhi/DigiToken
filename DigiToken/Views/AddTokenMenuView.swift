//
//  AddTokenMenuView.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/17/23.
//

import Foundation
import SwiftUI

struct AddTokenMenuView: View {
    @State var tokenName = ""
    @State var power = 1
    @State var toughness = 1
    @Binding var tokens: Array<TokenModel>
    @Binding var showAddTokenMenu: Bool
    
    var body: some View {
        HStack {
            VStack(spacing: 20) {
                TextField("Token Name", text: $tokenName)
                HStack {
                    Stepper(value: $power) {
                        Text("power: \(power)")
                    }
                }
                Stepper(value: $toughness) {
                    Text("toughness: \(toughness)")
                }
                Button("Create Token") {
                    createTokenView()
                    hideMenu()
                }
            }
        }.frame(width: 250, alignment: .trailing)
            .background(Color.gray)
            .shadow(radius: 1)
    }
    
    func createTokenView() {
        tokens.append(TokenModel(power: power, toughness: toughness, tokenName: tokenName))
    }
    
    func hideMenu() {
        showAddTokenMenu = false
    }
}
