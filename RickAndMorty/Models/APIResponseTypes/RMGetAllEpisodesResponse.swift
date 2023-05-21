//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 26.03.2023.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable { /* 963 copy from RMGetAllCharactersResponse and paste */
    struct Info: Codable { /* 963 */
        let count: Int  /* 963 */
        let pages: Int /* 963 */
        let next: String? /* 963 */
        let prev: String? /* 963 */
    }
    
    let info: Info /* 963 */
    let results: [RMEpisode] /* 963 */
}
