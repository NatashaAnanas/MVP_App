//
//  ImageLoaderService.swift
//  MVP_App
//
//  Created by Наталья Коновалова on 28.01.2026.
//

import UIKit

protocol ImageLoaderServiceProtocol {
    func loadImage(
        from urlString: String,
        completion: @escaping (UIImage?) -> Void
    )
    
    func getCachedImage(for urlString: String) -> UIImage?
}

final class ImageLoaderService: ImageLoaderServiceProtocol {

    private let session: URLSession
    private let cache = NSCache<NSString, UIImage>()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getCachedImage(for urlString: String) -> UIImage? {
        return cache.object(forKey: urlString as NSString)
    }

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let key = urlString as NSString

        if let cached = cache.object(forKey: key) {
            completion(cached)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        session.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let self,
                let data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            self.cache.setObject(image, forKey: key)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
