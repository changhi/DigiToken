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
    @EnvironmentObject var vm: ContentViewModel
    private let range = 0...10000
    
    var body: some View {
        HStack {
            VStack(spacing: 20) {
                TextField("Token Name", text: $tokenName)
                HStack {
                    Stepper(value: $power, in: range) {
                        Text("power: \(power)")
                    }
                }
                Stepper(value: $toughness, in: range) {
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
        vm.createToken(tokenName, power, toughness)
        print("hulk")
    }
    
    func hideMenu() {
        vm.showAddTokenMenu = false
    }
}
