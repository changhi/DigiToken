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
    var height: CGFloat = 190
    var width: CGFloat = 135
    
    var body: some View {
        if model.show {
            Text(model.imageURL != nil ? model.imageURL!.absoluteString : "nil")
            ZStack {
                VStack {
                    tokenOverlay(width, height, true, $model.rotation, $model.numTokens, $model.show)
                    tokenOverlay(width, height, false, $model.rotation, $model.numTokens, $model.show)
                }.zIndex(2)
                HStack(spacing: 5) {
                    if model.rotation == 90 {
                        Text("\(model.power * model.numTokens)/\(model.toughness * model.numTokens)")
                            .rotationEffect(.degrees(270))
                    }
                    ZStack {
                        if let url = model.imageURL {
                            // TODO: Find a way to reload the image when url changes
                            AsyncImage(url: url, placeholder: {Text("loading...")})
                                .aspectRatio(contentMode: .fit)
                                .zIndex(-1)
                        }
                        VStack {
                            HStack {
                                Text("\(model.numTokens)")
                                    .foregroundColor(.white)
                                Spacer()
                            }.padding([.leading, .top], 10)
                            Spacer()
                            HStack {
                                Spacer()
                                Text(model.tokenName)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(model.power)/\(model.toughness)")
                                    .foregroundColor(.white)
                                Spacer()
                            }.padding([.bottom], 10)
                        }
                    }.frame(width: width, height: height, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            }.rotationEffect(.degrees(model.rotation))
        }
    }
    
    //move to own file / class
    struct tokenOverlay: View {
        var width: CGFloat
        var height: CGFloat
        var increase: Bool
        @Binding var rotation: Double
        @Binding var numTokens: Int
        @Binding var show: Bool
        
        init(_ width: CGFloat, _ height: CGFloat, _ increase: Bool, _ rotation: Binding<Double>,
             _ numTokens: Binding<Int>, _ show: Binding<Bool>) {
            self._rotation = rotation
            self._numTokens = numTokens
            self._show = show
            self.width = width
            self.height = height / 2
            self.increase = increase
        }
        
        var body: some View {
            Color.clear
                .contentShape(Rectangle())
                .frame(width: width, height: height)
                .onTapGesture(count: 2) {
                    if rotation == 90 {
                        rotation = 0
                    } else {
                        rotation = 90
                    }
                }.onTapGesture {
                    if increase {
                        numTokens += 1
                    }
                    else {
                        numTokens -= 1
                        if numTokens < 0 {
                            numTokens = 1
                            show = false
                        }
                    }
                }
        }
    }
    
}

class TokenViewModel: ObservableObject, Hashable {
    static private var uid: Int = 0
    var id: Int
    @Published var tokenName: String
    @Published var rotation: Double
    @Published var power: Int
    @Published var toughness: Int
    @Published var numTokens: Int
    @Published var show: Bool
    @Published var imageURL: URL?
    
    init(_ service: ScryfallCardFetcherAPIServices) {
        self.id = TokenViewModel.generateId()
        self.tokenName = "token"
        self.rotation = 0.0
        self.power = 1
        self.toughness = 1
        self.numTokens = 1
        self.show = false
    }
    
    init(_ tokenName: String, _ power: Int, _ toughness: Int) {
        self.id = TokenViewModel.generateId()
        self.tokenName = tokenName
        self.rotation = 0.0
        self.power = power
        self.toughness = toughness
        self.numTokens = 1
        self.show = false
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
