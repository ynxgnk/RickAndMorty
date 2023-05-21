//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 14.03.2023.
//

import Foundation

enum RMCharacterStatus: String, Codable { /* 53 Codable - to decode from json */
    case alive = "Alive" /* 54 */
    case dead = "Dead" /* 54 */
    case `unknown` = "unknown" /* 54 */ // we can put word unknown in '' because in Swift unknown in some cases can be a keyword;
    
    var text: String { /* 324 */
        switch self { /* 324 */
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
        
    }
}
