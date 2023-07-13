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
    
    var body: some View {
        ZStack {
            Text("solider token")
                .frame(width: 100, height: 140, alignment: .center)
                .font(.system(size: 10))
                .background(Color.blue)
                .cornerRadius(15)
                .rotationEffect(.degrees(rotation))
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
