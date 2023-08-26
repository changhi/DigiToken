//
//  ScryfallAPIServices.swift
//  DigiToken
//
//  Created by Daniel Chang on 8/8/23.
//

import Foundation

enum ScryfallAPIError: Error {
    case genError
    case badHTTPResponse
    case invalidURL
    case error(NSError)
    case noData
}

protocol ScryfallCardFetcherAPIServices {
    func getCardInfo(cardName: String, completion: @escaping (Result<CardInfo, ScryfallAPIError>) -> ())
    func getCardImageURL(cardName: String) -> URL? 
}

class ScryfallTokenFetcherServices: ScryfallCardFetcherAPIServices {
    static let shared = ScryfallTokenFetcherServices()
    
    private let baseAPIURL = "https://api.scryfall.com/cards/named";
    private let urlSession = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            return decoder
        }()
    
    private init() {}
    
    private func generateURLQueryItems(cardName: String? = nil, format: String = "json") -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let cardName = cardName {
            items.append(URLQueryItem(name: "exact", value: cardName))
        }
        items.append(URLQueryItem(name: "format", value: format))
        return items
    }
    
    private func generateURL(with queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(string: baseAPIURL) else {
            return nil
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    private func excuteDataTask<D: Decodable>(with url: URL, completion: @escaping (Result<D, ScryfallAPIError>) -> ()) {
        urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.error(error as NSError)))
                print("error")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                completion(.failure(.badHTTPResponse))
                print("bad http")
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                print("no data")
                return
            }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            
            do {
                let model = try self.jsonDecoder.decode(D.self, from: data)
                completion(.success(model))
            } catch let error as NSError{
                completion(.failure(.error(error)))
            }
        }.resume()
    }
    
    func getCardInfo(cardName: String, completion: @escaping (Result<CardInfo, ScryfallAPIError>) -> ()) {
        guard let url = generateURL(with: generateURLQueryItems(cardName: cardName))  else {
            completion(.failure(.invalidURL))
            return
        }
        excuteDataTask(with: url) { (result: Result<CardInfo, ScryfallAPIError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCardImageURL(cardName: String) -> URL? {
        guard let url = generateURL(with: generateURLQueryItems(cardName: cardName, format: "image"))  else {
            return nil
        }
        //get card info then get url
        return url
    }
}

struct CardInfo: Decodable {
    let artist: String
    let card_faces: [CardImageInfo]
}
// TODO: need a way to check if card is double faced or error will be thrown
struct CardImageInfo: Decodable {
    let name: String
    let image_uris: [String:URL]
}

