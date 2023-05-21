//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 16.03.2023.
//

import UIKit /* 178 */

extension UIView { /* 179 */
    func addSubviews(_ views: UIView...) { /* 180 */
        views.forEach({ /* 181 */
            addSubview($0) /* 182 */
        })
    }
}

extension UIDevice { /* 2174 */
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone /* 2175 */
}
