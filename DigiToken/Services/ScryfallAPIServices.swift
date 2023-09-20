//
//  ScryfallAPIServices.swift
//  DigiToken
//
//  Created by Daniel Chang on 8/8/23.
//

import Foundation
import Combine
import SwiftUI

enum ScryfallAPIError: Error {
    case genError
    case badHTTPResponse
    case invalidURL
    case error(NSError)
    case noData
}

protocol ScryfallCardFetcherAPIServices {
    func getCardImageURL(cardName: String) -> AnyPublisher<URL?,Never>
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
    private var urlCache: [String:URL?]
    
    private init() {
        urlCache = [:]
    }
    
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
            _ = try! JSONSerialization.jsonObject(with: data, options: [])
            
            do {
                let model = try self.jsonDecoder.decode(D.self, from: data)
                completion(.success(model))
            } catch let error as NSError{
                completion(.failure(.error(error)))
            }
        }.resume()
    }
    
    func getCardImageURL(cardName: String) -> AnyPublisher<URL?, Never> {
        if urlCache[cardName] != nil {
            return Just<URL?>(urlCache[cardName]!).eraseToAnyPublisher()
        }
        guard let url = generateURL(with: generateURLQueryItems(cardName: cardName)) else { return Just<URL?>(nil)
                .eraseToAnyPublisher()}
        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CardInfo.self, decoder: jsonDecoder)
            .map { data in
                if data.image_uris != nil {
                    if let imageUrl = data.image_uris?["normal"] {
                        self.urlCache[cardName] = imageUrl
                        return imageUrl
                    }
                }
                if let cardFaces = data.card_faces {
                    for face in cardFaces {
                        if face.name == cardName {
                            if let imageUrl = face.image_uris["normal"] {
                                self.urlCache[cardName] = imageUrl
                                return imageUrl
                            }
                        }
                    }
                }
                return nil
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

struct CardInfo: Decodable {
    let artist: String
    let card_faces: [CardImageInfo]?
    let image_uris: [String:URL]?
    
    enum CodingKeys: CodingKey {
        case artist
        case card_faces
        case image_uris
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.artist = try container.decode(String.self, forKey: .artist)
        
        if container.contains(.card_faces) {
            card_faces = try container.decodeIfPresent([CardImageInfo].self, forKey: .card_faces)
        } else {
            card_faces = nil
        }
        
        if container.contains(.image_uris) {
            image_uris = try container.decode([String:URL].self, forKey: .image_uris)
        } else {
            image_uris = nil
        }
    }
}

struct CardImageInfo: Decodable {
    let name: String
    let image_uris: [String:URL]
}

struct ScryFallService: EnvironmentKey {
    static let defaultValue: ScryfallCardFetcherAPIServices = ScryfallTokenFetcherServices.shared
}

extension EnvironmentValues {
    var scryFallService: ScryfallCardFetcherAPIServices {
        get {
            return self[ScryFallService.self]
        }
        set { self[ScryFallService.self] = newValue }
    }
}
