//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 19.03.2023.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView { /* 377 final */
        static let identifier = "RMFooterLoadingCollectionReusableView" /* 378 */
    
    private let spinner: UIActivityIndicatorView = { /* 398 paste spinner from CharacterListView */
        let spinner = UIActivityIndicatorView(style: .large) /* 398 */
        spinner.hidesWhenStopped = true /* 398 */
        spinner.translatesAutoresizingMaskIntoConstraints = false /* 398 */
        return spinner /* 398 */
    }()
    
    override init(frame: CGRect) { /* 379 */
        super.init(frame: frame) /* 380 */
        backgroundColor = .systemBackground /* 384 */
        addSubview(spinner) /* 399 */
        addConstraints() /* 400 */
    }
    
    required init?(coder: NSCoder) { /* 381 */
        fatalError("Unsopported") /* 382 */
    }
    
    private func addConstraints() { /* 383 */
        NSLayoutConstraint.activate([ /* 401 */
            spinner.widthAnchor.constraint(equalToConstant: 100), /* 402 copy constraints from RMCharacterListView */
            spinner.heightAnchor.constraint(equalToConstant: 100), /* 402 */
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor), /* 402 */
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor), /* 402 */
        ])
    }
    
    public func startAnimating() {/* 397 */
        spinner.startAnimating() /* 403 */
    }
}
