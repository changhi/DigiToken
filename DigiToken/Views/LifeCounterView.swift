//
//  LifeCounterView.swift
//  DigiToken
//
//  Created by Daniel Chang on 9/27/23.
//

import Combine
import SwiftUI
import Foundation

struct LifeCounterView: View {
    @State var lifeTotal: Int
    
    
    var body: some View {
        HStack {
            Button("-") { lifeTotal -= 1 }
            Text("\(lifeTotal)")
                .frame(width: 100)
            Button("+") { lifeTotal += 1 }
        }
        .onTapGesture(count: 2) {
            lifeTotal = 40
        }
    }
    
    
}
