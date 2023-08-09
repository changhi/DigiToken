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
    func getCardInfo(cardName: String, completion: @escaping (Result<testDecodable, ScryfallAPIError>) -> ())
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
    
    private func generateURLQueryItems(cardName: String? = nil) -> [URLQueryItem] {
        var items = [URLQueryItem]()
        if let cardName = cardName {
            items.append(URLQueryItem(name: "exact", value: cardName))
        }
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
        print("exe")
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
            print(json)
        }.resume()
    }
    
    func getCardInfo(cardName: String, completion: @escaping (Result<testDecodable, ScryfallAPIError>) -> ()) {
        guard let url = generateURL(with: generateURLQueryItems(cardName: cardName))  else {
            completion(.failure(.invalidURL))
            return
        }
        print(url)
        excuteDataTask(with: url) { (result: Result<testDecodable, ScryfallAPIError>) in
            
        }
        print("end")
    }
}


struct testDecodable: Decodable {
    
}
