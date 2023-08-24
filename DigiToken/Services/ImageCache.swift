//
//  ImageCache.swift
//  DigiToken
//
//  Created by Daniel Chang on 8/24/23.
//

import Foundation
import SwiftUI

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get {
            print(key)
            return cache.object(forKey: key as NSURL)
        }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL)}
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get {
            return self[ImageCacheKey.self]
        }
        set { self[ImageCacheKey.self] = newValue }
    }
}


