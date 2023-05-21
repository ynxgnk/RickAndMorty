//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 31.03.2023.
//

import UIKit

final class RMLocationTableViewCell: UITableViewCell { /* 1417 add final */
    static let cellIdentifier = "RMLocationTableViewCell" /* 1418 */
    
    private let nameLabel: UILabel = { /* 1462 */
        let label = UILabel() /* 1463 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 1464 */
        label.font = .systemFont(ofSize: 20, weight: .medium) /* 1465 */
        return label /* 1466 */
    }()
    
    private let typeLabel: UILabel = { /* 1467 */
        let label = UILabel() /* 1468 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 1469 */
        label.font = .systemFont(ofSize: 15, weight: .regular) /* 1470 */
        label.textColor = .secondaryLabel /* 1493 */
        return label /* 1471 */
    }()
    
    private let dimensionLabel: UILabel = { /* 1472 */
        let label = UILabel() /* 1473 */
        label.textColor = .secondaryLabel /* 1494 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 1474 */
        label.font = .systemFont(ofSize: 15, weight: .light) /* 1475 */
        return label /* 1476 */
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { /* 1419 init style */
        super.init(style: style, reuseIdentifier: reuseIdentifier) /* 1420 */
//        contentView.backgroundColor = .systemBackground /* 1426 */ /* 1457 change from .red to SystemBackground */ /* 1477 comment*/
        contentView.addSubviews(nameLabel, typeLabel, dimensionLabel) /* 1477 */
        addConstraints() /* 1478 */
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator /* 1492 different, (part 37, 8:25) */
    }
  
    required init?(coder: NSCoder) { /* 1421 */
        fatalError() /* 1422 */
    }

    private func addConstraints() { /* 1479 */
        NSLayoutConstraint.activate([ /* 1486 */
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), /* 1487 */
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10), /* 1487 */
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10), /* 1487 */
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10), /* 1488 */
            typeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10), /* 1488 */
            typeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10), /* 1488 */
            
            dimensionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10), /* 1489 */
            dimensionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10), /* 1489 */
            dimensionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10), /* 1489 */
            dimensionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10) /* 1489 */
            
        ])
    }
    
    override func prepareForReuse() { /* 1423 prepareForReuse */
        super.prepareForReuse() /* 1424 */
        nameLabel.text = nil /* 1480 */
        typeLabel.text = nil /* 1481 */
        dimensionLabel.text = nil /* 1482 */
    }
    
    public func configure(with viewModel: RMLocationTableViewCellViewModel) { /* 1425 */
        nameLabel.text = viewModel.name /* 1483 */
        typeLabel.text = viewModel.type /* 1484 */
        dimensionLabel.text = viewModel.dimension /* 1485 */
    }
}
