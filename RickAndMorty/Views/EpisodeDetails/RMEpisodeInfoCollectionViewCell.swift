//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 28.03.2023.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell { /* 1107 add final */
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell" /* 1136 */
    
    private let titleLabel: UILabel = { /* 1185 */
        let label = UILabel() /* 1186 */
        label.font = .systemFont(ofSize: 20, weight: .medium) /* 1187 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 1188 */
        return label /* 1189 */
    }()
    
    private let valueLabel: UILabel = { /* 1190 copy from titleLabel and paste */
        let label = UILabel() /* 1191 */
        label.font = .systemFont(ofSize: 20, weight: .regular) /* 1192 */
        label.textAlignment = .right /* 1195 */
        label.numberOfLines = 0 /* 1196 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 1193 */
        return label /* 1194 */
    }()
    
    override init(frame: CGRect) { /* 1137 */
        super.init(frame: frame) /* 1138 */
        contentView.backgroundColor = .secondarySystemBackground /* 1139 */ /* 1178 change color from red to secondarySystemBackground */
        contentView.addSubviews(titleLabel, valueLabel) /* 1197 */
        setUpLayer() /* 1184 */
        addConstraints() /* 1198 */
    }
    
    required init(coder: NSCoder) { /* 1140 */
        fatalError() /* 1141 */
    }
    
    private func setUpLayer() { /* 1179 */
        layer.cornerRadius = 8 /* 1180 */
        layer.masksToBounds = true /* 1181 */
        layer.borderWidth = 1 /* 1182 */
        layer.borderColor = UIColor.secondaryLabel.cgColor /* 1183 */
    }
    
    private func addConstraints() { /* 1199 */
        NSLayoutConstraint.activate([ /* 1200 */
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4), /* 1205 */
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10), /* 1205 */
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4), /* 1205 */
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4), /* 1206 */
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10), /* 1206 */
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4), /* 1206 */
            
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47), /* 1207 */
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47) /* 1208 */
        ])
        
//        titleLabel.backgroundColor = .red /* 1209 */
//        valueLabel.backgroundColor = .green /* 1210 */
    }
    
    override func prepareForReuse() { /* 1142 prepareForReuse */
        super.prepareForReuse() /* 1143 */
        titleLabel.text = nil /* 1201 to reset text */
        valueLabel.text = nil /* 1202 */
    }
    
    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) { /* 1144 */
        titleLabel.text = viewModel.title /* 1203 */
        valueLabel.text = viewModel.value /* 1204 */
    }
}
