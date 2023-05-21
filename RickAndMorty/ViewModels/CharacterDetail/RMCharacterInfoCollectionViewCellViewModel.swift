//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 22.03.2023.
//

import UIKit /* 758 UIKit */

final class RMCharacterInfoCollectionViewCellViewModel { /* 613 */
    private let type: `Type` /* 741  */
    private let value: String  /* 671 */ /* 753 change to private */
    
    static let dateFormatter: DateFormatter = { /* 795 */
        //Format
        let formatter = DateFormatter() /* 796 */
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ" /* 801 */
        formatter.timeZone = .current /* 797 */
        return formatter /* 798 */
    }()
    
    static let shortDateFormatter: DateFormatter = { /* 804 */
        //Format
        let formatter = DateFormatter() /* 805 */
        formatter.dateStyle = .medium /* 806 */
        formatter.timeStyle = .short /* 807 */
        formatter.timeZone = .current /* 814 */
        return formatter /* 808 */
    }()
    
    public var title: String { /* 672 */ /* 740 */
        type.displayTitle /* 751 */
    }
    
    public var displayValue: String { /* 754 */
        if value.isEmpty { return "None" } /* 755 */
        
//        if type == .created { /* 802 */
//            print(value) /* 803 */
//        }
        
//        if type == .created { /* 811 */
//            print("format: \(value)") /* 812 */
//        }
        
        if let date = Self.dateFormatter.date(from: value) /* 799 */,
           type == .created { /* 793 */
//            let result = Self.shortDateFormatter.string(from: date) /* 809 Self - because static */
//            print(date) /* 794 */ /* 800 change value to date */
//            print("Result: "+String(describing: date)) /* 810 */
            return Self.shortDateFormatter.string(from: date) /* 813 */
        }
        
        return value /* 756 */
    }

    public var iconImage: UIImage? { /* 768 */
        return type.iconImage /* 769 */
    }
    
    public var tintColor: UIColor { /* 783 */
        return type.tintColor /* 784 */
    }
    
    enum `Type`: String { /* 737 */
        case status /* 738 */
        case gender /* 738 */
        case type /* 738 */
        case species /* 738 */
        case origin /* 738 */
        case created /* 738 */
        case location /* 738 */
        case episodeCount /* 738 */
        
        var tintColor: UIColor {/* 770 */
            switch self { /* 771 */
            case .status  :
                return .systemBlue /* 772 */
            case .gender  :
                return .systemRed /* 773 */
            case .type    :
                return .systemPurple /* 774 */
            case .species :
                return .systemGreen /* 775 */
            case .origin  :
                return .systemOrange /* 776 */
            case .created :
                return .systemPink /* 777 */
            case .location:
                return .systemYellow /* 778 */
            case .episodeCount:
                return .systemMint /* 779 */
            }
        }
        
        var iconImage: UIImage? {/* 757 */
            switch self { /* 759 */
            case .status  :
                return UIImage(systemName: "bell") /* 760 */
            case .gender  :
                return UIImage(systemName: "bell") /* 761 */
            case .type    :
                return UIImage(systemName: "bell") /* 762 */
            case .species :
                return UIImage(systemName: "bell") /* 763 */
            case .origin  :
                return UIImage(systemName: "bell") /* 764 */
            case .created :
                return UIImage(systemName: "bell") /* 765 */
            case .location:
                return UIImage(systemName: "bell") /* 766 */
            case .episodeCount:
                return UIImage(systemName: "bell") /* 767 */
            }
        }
        
        var displayTitle: String { /* 741 */
            /*
            switch self { /* 742 */
            case .status  :
                return "Status"/* 743 */
            case .gender  :
                return "Gender"/* 744 */
            case .type    :
                return "Type"/* 745 */
            case .species :
                return "Species"/* 746 */
            case .origin  :
                return "Origin"/* 747 */
            case .created :
                return "Created"/* 748 */
            case .location:
                return "Location"/* 749 */
            case .episodeCount:
                return "Episode Count" /* 750 */
            }
             */
            
            switch self { /* 788 */
            case .status, /* 789 */
             .gender, /* 789 */
             .type, /* 789 */
             .species, /* 789 */
             .origin, /* 789 */
             .created, /* 789 */
             .location: /* 789 */
                return rawValue.uppercased() /* 790 */
             case .episodeCount: /* 791 */
                return "EPISODE COUNT" /* 792 */
            }
        }
    }

    
    init(type: `Type`, value: String /*title: String*/) { /* 614 */ /* 739 add type and remove title */
        self.value = value /* 673 */
//        self.title = title /* 674 */
        self.type = type /* 742 */
    }
}
