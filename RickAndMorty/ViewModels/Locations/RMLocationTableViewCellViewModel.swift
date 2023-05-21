//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 31.03.2023.
//

import Foundation

struct RMLocationTableViewCellViewModel: Hashable, Equatable { /* 1427 */ /* 1452 add Hashable and Equatable */
    private let location: RMLocation /* 1442 */
    
    init(location: RMLocation) { /* 1441 */
        self.location = location /* 1443 */
    }
    
    public var name: String { /* 1444 */
        return location.name /* 1445 */
    }
    
    public var type: String { /* 1446 */
        return "Type: "+location.type /* 1447 */
    }
    
    public var dimension: String { /* 1448 */
        return location.dimension /* 1449 */
    }
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool { /* 1453 */
        return lhs.location.id == rhs.location.id /* 1456 */
    }
    
    func hash(into hasher: inout Hasher) { /* 1454 hasInto */
        hasher.combine(name) /* 1455 */
        hasher.combine(location.id) /* 1455 */
        hasher.combine(dimension) /* 1455 */
        hasher.combine(type) /* 1455 */
    }
}
