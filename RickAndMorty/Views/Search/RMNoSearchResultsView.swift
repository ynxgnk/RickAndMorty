//
//  RMNoSearchResultsView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 02.04.2023.
//

import UIKit

final class RMNoSearchResultsView: UIView { /* 1557 */

    private let viewModel = RMNoSearchResultsViewViewModel() /* 1569 */
    
    private let iconView: UIImageView = { /* 1571 */
        let iconView = UIImageView() /* 1572 */
        iconView.contentMode = .scaleAspectFit /* 1573 */
        iconView.tintColor = .systemBlue /* 1574 */
        iconView.translatesAutoresizingMaskIntoConstraints = false /* 1575 */
        return iconView /* 1576 */
    }()
    
    private let label: UILabel = { /* 1577 */
        let label = UILabel() /* 1578 */
        label.textAlignment = .center /* 1579 */
        label.font = .systemFont(ofSize: 20, weight: .medium) /* 1580 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 1581 */
        return label /* 1582 */
    }()
    
    override init(frame: CGRect) { /* 1562 */
        super.init(frame: frame) /* 1563 */
        isHidden = true /* 1612 */
        translatesAutoresizingMaskIntoConstraints = false /* 1570 */
        addSubviews(iconView, label) /* 1583 */
        addConstraints() /* 1585 */
        configure() /* 1587 */
    }
    
    required init?(coder: NSCoder) { /* 1564 */
        fatalError() /* 1565 */
    }
    
    private func addConstraints() { /* 1584 */
        NSLayoutConstraint.activate([ /* 1590 */
            iconView.widthAnchor.constraint(equalToConstant: 90), /* 1591 */
            iconView.heightAnchor.constraint(equalToConstant: 90), /* 1591 */
            iconView.topAnchor.constraint(equalTo: topAnchor), /* 1591 */
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor), /* 1591 */
            
            label.leftAnchor.constraint(equalTo: leftAnchor), /* 1592 */
            label.rightAnchor.constraint(equalTo: rightAnchor), /* 1592 */
            label.bottomAnchor.constraint(equalTo: bottomAnchor), /* 1592 */
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10) /* 1592 */
        ])
    }
    
    private func configure() { /* 1586 */
        label.text = viewModel.title /* 1588 */
        iconView.image = viewModel.image /* 1589 */
    }
}
