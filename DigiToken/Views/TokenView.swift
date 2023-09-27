//
//  TokenView.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/12/23.
//

import Combine
import Foundation
import SwiftUI

struct TokenCardView: View {
    @Binding var model: TokenViewModel
    var height: CGFloat = 190
    var width: CGFloat = 135
    
    var body: some View {
        if model.show {
            ZStack {
                VStack {
                    tokenOverlay(width, height, true, $model.rotation, $model.numTokens, $model.show, $model.addCounters, $model.plusOneCounters)
                    tokenOverlay(width, height, false, $model.rotation, $model.numTokens, $model.show, $model.addCounters, $model.plusOneCounters)
                }.zIndex(2)
                HStack(spacing: 5) {
                    if model.rotation == 90 {
                        Text("\((model.power + model.plusOneCounters) * model.numTokens)/\((model.toughness + model.plusOneCounters) * model.numTokens)")
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
                            if model.plusOneCounters != 0 {
                                plusOneView($model.plusOneCounters).zIndex(1)
                            }
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
    
    struct plusOneView: View {
        @Binding var plusOneCounters: Int
        
        init(_ plusOneCounters: Binding<Int>) {
            self._plusOneCounters = plusOneCounters
        }
        
        var body: some View {
            VStack(alignment: .center) {
                Text("+\(plusOneCounters)/+\(plusOneCounters)")
                    .foregroundColor(.black)
            }.frame(width: 50, height: 50, alignment: .center)
                .background(Color.white)
                .cornerRadius(15)
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
        @Binding var addCounters: Bool
        @Binding var numCounters: Int
        
        init(_ width: CGFloat, _ height: CGFloat, _ increase: Bool, _ rotation: Binding<Double>,
             _ numTokens: Binding<Int>, _ show: Binding<Bool>, _ addCounters: Binding<Bool>, _ numCounters: Binding<Int>) {
            self._rotation = rotation
            self._numTokens = numTokens
            self._show = show
            self.width = width
            self.height = height / 2
            self.increase = increase
            self._addCounters = addCounters
            self._numCounters = numCounters
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
                        if addCounters { numCounters += 1 }
                        else { numTokens += 1 }
                    }
                    else {
                        if addCounters { numCounters -= 1 }
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
    @Published var plusOneCounters: Int
    @Published var addCounters: Bool
    
    init(_ service: ScryfallCardFetcherAPIServices) {
        self.id = TokenViewModel.generateId()
        self.tokenName = "token"
        self.rotation = 0.0
        self.power = 1
        self.toughness = 1
        self.numTokens = 1
        self.show = false
        self.addCounters = false
        self.plusOneCounters = 0
    }
    
    init(_ tokenName: String, _ power: Int, _ toughness: Int) {
        self.id = TokenViewModel.generateId()
        self.tokenName = tokenName
        self.rotation = 0.0
        self.power = power
        self.toughness = toughness
        self.numTokens = 1
        self.show = false
        self.addCounters = false
        self.plusOneCounters = 0
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
