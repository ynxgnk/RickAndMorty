//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 14.03.2023.
//

import Foundation

/// Represents unique API endpoints
@frozen enum RMEndpoint: String, Hashable, CaseIterable { /* 41 String - when saying RMEndpoint.character.rawValue, this will spit out a "character" as a string;*/ /* 905 add Hashable and CaseIterable(to loop throw this 3 cases) */
   ///Endpoint to get character sinfo
    case character /* 42 */
    ///Endpoint to get locations info
    case location /* 43 */
    ///Endpoint to get episodes info
    case episode /* 44 */
}
