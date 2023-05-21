//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 21.03.2023.
//

import Foundation

final class RMImageLoader { /* 493 */
    static let shared = RMImageLoader() /* 494 */
    
    private var imageDataCache = NSCache<NSString, NSData>() /* 498 NSCache - handles getting rid of caches in session(memory) in case memory is getting low */
    
    private init() {} /* 495 */
    
    /// Get Image content with URL
    /// - Parameters:
    ///   - url: Source url
    ///   - completion: Callback
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) { /* 496 copy from RMCharacterCollectionViewCellViewModel and paste */
        let key = url.absoluteString as NSString /* 499 */
        if let data = imageDataCache.object(forKey: key) { /* 503 */
//            print("Reading from cache: \(key)") /* 506 */
            completion(.success(data as Data)) /* 504 */ // NSData == Data | NSString == String
            return /* 505 */
        }
        
        let request = URLRequest(url: url) /* 496 */
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in /* 496 */ /* 502 add weak self */
            guard let data = data, error == nil else { /* 266 */
//                completion(.failure(error ?? URLError(.badServerResponse))) /* 496 */
                return /* 496 */
            }
            let value = data as NSData /* 500 */
            self?.imageDataCache.setObject(value, forKey: key) /* 501 */
            completion(.success(data)) /* 496 */
        }
        task.resume() /* 496 */
    }
}
