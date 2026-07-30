//
//  ImageLoader.swift
//  DoordashAI
//

import UIKit

enum ImageLoaderError: Error {
    case invalidData
}

protocol ImageLoading {
    func loadImage(from url: URL) async throws -> UIImage
}

/// Download simples de imagem com cache em memória. Sem libs de terceiros.
final class ImageLoader: ImageLoading {

    static let shared = ImageLoader()

    private let session: URLSession
    private let cache = NSCache<NSURL, UIImage>()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImage(from url: URL) async throws -> UIImage {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }

        let (data, _) = try await session.data(from: url)
        guard let image = UIImage(data: data) else {
            throw ImageLoaderError.invalidData
        }

        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
