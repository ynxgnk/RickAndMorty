//
//  RMTableLoadingFooterView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 07.04.2023.
//

import UIKit

final class RMTableLoadingFooterView: UIView { /* 2070 add final */

    private let spinner: UIActivityIndicatorView = { /* 2075 */
        let spinner = UIActivityIndicatorView() /* 2076 */
        spinner.translatesAutoresizingMaskIntoConstraints = false /* 2077 */
        spinner.hidesWhenStopped = true /* 2078 */
        return spinner /* 2079 */
    }()
    
    override init(frame: CGRect) { /* 2071 */
        super.init(frame: frame) /* 2072 */
        
//        translatesAutoresizingMaskIntoConstraints = false /* 2080 */
        addSubview(spinner) /* 2081 */
        spinner.startAnimating() /* 2082 */
        
        addConstraints() /* 2083 */
    }
    
    required init?(coder: NSCoder) { /* 2073 */
        fatalError() /* 2074 */
    }
    
    private func addConstraints() { /* 2084 */
        NSLayoutConstraint.activate([ /* 2085 */
            spinner.widthAnchor.constraint(equalToConstant: 55), /* 2086 */
            spinner.heightAnchor.constraint(equalToConstant: 55), /* 2086 */
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor), /* 2086 */
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor), /* 2086 */
        ])
    }
}
