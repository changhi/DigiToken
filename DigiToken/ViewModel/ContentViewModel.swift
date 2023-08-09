//
//  ContentViewModel.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/13/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var tokens: Array<TokenViewModel>
    @Published var showAddTokenMenu: Bool = false
    
    let service: ScryfallCardFetcherAPIServices
    
    init(service: ScryfallCardFetcherAPIServices = ScryfallTokenFetcherServices.shared) {
        self.tokens = Array()
        self.showAddTokenMenu = false
        self.service = service
        for _ in 0..<4 {
            tokens.append(TokenViewModel())
        }
    }
    
    func resetBoard() {
        tokens = Array<TokenViewModel>()
        TokenViewModel.resetUID()
        for _ in 0..<4 {
            tokens.append(TokenViewModel())
        }
    }
    
    func toggleAddTokenMenu() {
        showAddTokenMenu = !showAddTokenMenu
    }
    
    func createToken(_ tokenName: String, _ power: Int, _ toughness: Int) {
        for i in 0..<tokens.count {
            if !tokens[i].show {
                tokens[i].power = power
                tokens[i].toughness = toughness
                tokens[i].tokenName = tokenName
                tokens[i].show = true
                break
            }
        }
        var confirmedResult: Result<testDecodable, ScryfallAPIError>?
        service.getCardInfo(cardName: "human") { [weak self](result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.showAddTokenMenu = true
                    print(data)
                case .failure(let error):
                    self.showAddTokenMenu = true
                    print(error)
                }
            }
        }
    }
    
    func change() {
        self.objectWillChange.send()
    }
}
