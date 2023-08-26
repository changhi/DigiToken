//
//  AsyncImage.swift
//  DigiToken
//
//  Created by Daniel Chang on 8/22/23.
//

import Combine
import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    private var cancellable: AnyCancellable?
    private var cache: ImageCache?
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        if let image = cache?[url] {
            self.image = image
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map {UIImage(data: $0.data)}
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] in self?.cache($0) })
            .receive(on: DispatchQueue.main)
            .sink {[weak self] in self?.image = $0}
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}

