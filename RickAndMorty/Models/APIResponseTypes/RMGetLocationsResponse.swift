//
//  RMGetLocationsResponse.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 31.03.2023.
//

import Foundation

struct RMGetAllLocationsResponse: Codable { /* 1408 copy from RMGetAllEpisodesResponse and paste */
    struct Info: Codable { /* 1408 */
        let count: Int  /* 1408 */
        let pages: Int /* 1408 */
        let next: String? /* 1408 */
        let prev: String? /* 1408 */
    }
    
    let info: Info /* 1408 */
    let results: [RMLocation] /* 1408 */
}
