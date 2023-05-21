//
//  RMGetCharactersResponse.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 15.03.2023.
//

import Foundation

struct RMGetAllCharactersResponse: Codable { /* 133 */
    struct Info: Codable { /* 134 */
        let count: Int  /* 135 */
        let pages: Int /* 136 */
        let next: String? /* 137 */
        let prev: String? /* 138 */
    }
    
    let info: Info /* 135 */
    let results: [RMCharacter] /* 139 */
}


