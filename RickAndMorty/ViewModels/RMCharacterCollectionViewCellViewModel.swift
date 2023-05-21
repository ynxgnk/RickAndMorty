//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 16.03.2023.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable { /* 223 */ /* 249 add final class */ /* 482 add Hashable and Equatable(allows the equation of this object whether two things are equal to one another) */
    public let characterName: String /* 251 */
    private let characterStatus: RMCharacterStatus /* 252 */
    private let characterImageUrl: URL? /* 253 */
    
    //MARK: - Init
    
    init( /* 250 */
        characterName: String, /* 254 */
        characterStatus: RMCharacterStatus, /* 255 */
        characterImageUrl: URL? /* 256 */
    ) {
        self.characterName = characterName /* 259 */
        self.characterStatus = characterStatus /* 259 */
        self.characterImageUrl = characterImageUrl /* 259 */
    }
    
    public var characterStatusText: String { /* 257 */
        return "Status: \(characterStatus.text)" /* 333 */
        //return characterStatus.rawValue /* 258  */
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) { /* 260 */
        //TODO: Abstract to Image Manager
        guard let url = characterImageUrl else { /* 261 */
            completion(.failure(URLError(.badURL))) /* 265 */
            return /* 261 */
        }
        /*
        let request = URLRequest(url: url) /* 262 */
        let task = URLSession.shared.dataTask(with: request) { data, _, error in /* 263 */
            guard let data = data, error == nil else { /* 266 */
                completion(.failure(error ?? URLError(.badServerResponse))) /* 268 */
                return /* 267 */
            }
            completion(.success(data)) /* 269 */
        }
        task.resume() /* 264 */
        */
        RMImageLoader.shared.downloadImage(url, completion: completion) /* 497 call RMImageLoader with its data */
    }
    
    //MARK: - Hashable
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool { /* 487 */
        return lhs.hashValue == rhs.hashValue /* 488 */
    }
    
    func hash(into hasher: inout Hasher) { /* 483 has(into) */
        hasher.combine(characterName) /* 484 */
        hasher.combine(characterStatus) /* 485 */
        hasher.combine(characterImageUrl) /* 486 */
    }
}
