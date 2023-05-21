//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 22.03.2023.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel { /* 617 */
    private let imageUrl: URL? /* 669 */
    init(imageUrl: URL?) { /* 618 */
        self.imageUrl = imageUrl /* 670 */
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) { /* 687 */
        guard let imageUrl = imageUrl else { /* 687 */
            completion(.failure(URLError(.badURL))) /* 688 */
            return /* 689 */
        }
        RMImageLoader.shared.downloadImage(imageUrl, completion: completion) /* 690 */
    }
    
}
