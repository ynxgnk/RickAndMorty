//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 29.03.2023.
//

import UIKit /* 1239 UIKit */

struct RMSettingsCellViewModel: Identifiable { /* 1238 */ /* 1268 add Identifiable and Hashable */
    let id = UUID() /* 1269 will create a unique ID for each of viewModel instances we create */ /* 1308 remove Hashable */
   
    public let type: RMSettingsOption /* 1254 */
    public let onTapHandler: (RMSettingsOption) -> Void /* 1306 */
    //MARK: - Init
    
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) { /* 1255 */ /* 1305 add ontapHandler */
        self.type = type /* 1256 */
        self.onTapHandler = onTapHandler /* 1307 */
    }
    
    //MARK: - Public
    
    public var image: UIImage? { /* 1240 */
        return type.iconImage /* 1257 */
    }
    
    public var title: String { /* 1241 */
        return type.displayTitle /* 1258 */
    }
    
    public var iconContainerColor: UIColor { /* 1266 */
        return type.iconContainerColor /* 1267 */
    }
}
