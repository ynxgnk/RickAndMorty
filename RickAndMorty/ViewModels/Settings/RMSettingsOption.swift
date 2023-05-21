//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 29.03.2023.
//

import UIKit /* 1244 UIKit */

enum RMSettingsOption: CaseIterable { /* 1242 */
    case rateApp /* 1243 */
    case contactUs /* 1243 */
    case terms /* 1243 */
    case privacy /* 1243 */
    case apiReference /* 1243 */
    case viewSeries /* 1243 */
    case viewCode /* 1243 */
    
    var targetUrl: URL? { /* 1319 */
        switch self { /* 1320 */
        case .rateApp: /* 1321 */
            return nil /* 1322 */
        case .contactUs: /* 1321 */
            return URL(string: "https://www.instagram.com/ynxgnk/") /* 1322 */
        case .terms: /* 1321 */
            return URL(string: "https://iosacademy.io/terms") /* 1322 */
        case .privacy: /* 1321 */
            return URL(string: "https://iosacademy.io/privacy") /* 1322 */
        case .apiReference: /* 1321 */
            return URL(string: "https://rickandmortyapi.com/documentation/#get-a-single-episode") /* 1322 */
        case .viewSeries: /* 1321 */
            return URL(string: "https://www.youtube.com/playlist?list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4y") /* 1322 */
        case .viewCode: /* 1321 */
            return URL(string: "https://github.com/AfrazCodes/RickAndMortyIOSApp") /* 1322 */
        }
    }
    
    var displayTitle: String { /* 1245 */
        switch self { /* 1248 */
        case .rateApp: /* 1249 */
            return "Rate App" /* 1250 */
        case .contactUs: /* 1249 */
            return "Contact Us" /* 1250 */
        case .terms: /* 1249 */
            return "Terms of Service" /* 1250 */
        case .privacy: /* 1249 */
            return "Privacy Policy" /* 1250 */
        case .apiReference: /* 1249 */
            return "API Reference" /* 1250 */
        case .viewSeries: /* 1249 */
            return "View Video Series" /* 1250 */
        case .viewCode: /* 1249 */
            return "View App Code" /* 1250 */
        }
    }
    
    var iconContainerColor: UIColor { /* 1262 */
        switch self { /* 1263 */
        case .rateApp: /* 1264 */
            return .systemBlue /* 1265 */
        case .contactUs: /* 1264 */
            return .systemGreen /* 1265 */
        case .terms: /* 1264 */
            return .systemRed /* 1265 */
        case .privacy: /* 1264 */
            return .systemYellow /* 1265 */
        case .apiReference: /* 1264 */
            return .systemOrange /* 1265 */
        case .viewSeries: /* 1264 */
            return .systemPurple /* 1265 */
        case .viewCode: /* 1264 */
            return .systemPink /* 1265 */
        }
    }
    
    var iconImage: UIImage? { /* 1246 */
        switch self { /* 1251 */
        case .rateApp: /* 1252 */
            return UIImage(systemName: "star.fill") /* 1253 */
        case .contactUs: /* 1252 */
            return UIImage(systemName: "paperplane") /* 1253 */
        case .terms: /* 1252 */
            return UIImage(systemName: "doc") /* 1253 */
        case .privacy: /* 1252 */
            return UIImage(systemName: "lock") /* 1253 */
        case .apiReference: /* 1252 */
            return UIImage(systemName: "list.clipboard") /* 1253 */
        case .viewSeries: /* 1252 */
            return UIImage(systemName: "tv.fill") /* 1253 */
        case .viewCode: /* 1252 */
            return UIImage(systemName: "hammer.fill") /* 1253 */
        }
//        return nil /* 1247 */
    }
}
