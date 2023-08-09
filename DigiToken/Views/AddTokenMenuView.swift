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
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                Spacer().frame(height: 2)
                TextField("Token Name", text: $tokenName)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                Stepper(value: $power, in: range) {
                    Text("power: \(power)")
                }
                Stepper(value: $toughness, in: range) {
                    Text("toughness: \(toughness)")
                }
                Button("Create Token") {
                    createToken()
                    hideMenu()
                }
                Spacer().frame(height: 2)
            }
        }.frame(width: 350)
            .background(Color.gray)
            .cornerRadius(25.0)
            .shadow(radius: 1)
    }
    
    func createToken() {
        vm.createToken(tokenName, power, toughness)
    }
    
    func hideMenu() {
        vm.showAddTokenMenu = false
    }
}
