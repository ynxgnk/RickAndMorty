//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 02.04.2023.
//

import Foundation

final class RMSearchInputViewViewModel { /* 1560 */
    private let type: RMSearchViewController.Config.`Type` /* 1636 */
    
    enum DynamicOption: String { /* 1645 */
        case status = "Status" /* 1646 */
        case gender = "Gender" /* 1646 */
        case locationType = "Location Type" /* 1646 */
        
        var queryArgument: String { /* 1810 */
            switch self { /* 1811 */
            case .status: return "status" /* 1812 */
            case .gender: return "gender" /* 1813 */
            case .locationType: return "type" /* 1814 */
            }
        }
        
        var choices: [String] { /* 1761 */
            switch self { /* 1762 */
            case .status: /* 1763 */
                return ["alive", "dead", "unknown"] /* 1764 */
            case .gender: /* 1763 */
                return ["male", "female", "genderless", "unknown"] /* 1764 */
            case .locationType: /* 1763 */
                return ["cluster", "planet", "microverse"] /* 1764 */
            }
        }
    }
    
    init(type: RMSearchViewController.Config.`Type`) { /* 1561 */ /* 1637 add parameter type */
        self.type = type /* 1638 */
    }
    
    //MARK: - Public
    
    public var hasDynamicOptions: Bool { /* 1639 */
        switch self.type { /* 1640 */
        case .character, .location: /* 1641 */
            return true /* 1642 */
        case .episode: /* 1643 */
            return false /* 1644 */
        }
    }
    
    public var options: [DynamicOption] { /* 1647 */
        switch self.type { /* 1648 */
        case .character: /* 1649 */
            return [.status, .gender] /* 1650 */
        case .location: /* 1649 */
            return [.locationType] /* 1650 */
        case .episode: /* 1649 */
            return [] /* 1650 */
        }
    }
    
    public var searchPlaceholderText: String { /* 1651 */
        switch self.type { /* 1652 */
        case .character: /* 1653 */
            return "Character Name" /* 1654 */
        case .location: /* 1653 */
            return "Location Name" /* 1654 */
        case .episode: /* 1653 */
            return "Episode Title" /* 1654 */
        }
    }
}
