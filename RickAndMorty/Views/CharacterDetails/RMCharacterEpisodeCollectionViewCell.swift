//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 22.03.2023.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell" /* 643 */
    
    private let seasonLabel: UILabel = { /* 863 copy from RMCharacterInfo...ViewCell and paste  */
        let label = UILabel() /* 864 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 864 */
        label.font = .systemFont(ofSize: 20, weight: .semibold) /* 864 */
        return label /* 864 */
    }()
    
    private let nameLabel: UILabel = { /* 865 copy from RMCharacterInfo...ViewCell and paste */
        let label = UILabel() /* 865 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 865 */
        label.font = .systemFont(ofSize: 22, weight: .regular) /* 865 */
        return label /* 865 */
    }()
    
    private let airDateLabel: UILabel = { /* 866 copy from RMCharacterInfo...ViewCell and paste */
        let label = UILabel() /* 866 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 866 */
        label.font = .systemFont(ofSize: 18, weight: .light) /* 866 */
        return label /* 866 */
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) { /* 659 */
        super.init(frame: frame) /* 660 */
        contentView.backgroundColor = .tertiarySystemBackground /* 818 */
        setUpLayer() /* 969 */
//        contentView.layer.cornerRadius = 8 /* 819 */
//        contentView.layer.borderWidth = 2 /* 867 */
//        contentView.layer.borderColor = UIColor.systemBlue.cgColor /* 868 */
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel) /* 869 */
        setUpConstraints() /* 875 */
    }
    
    required init?(coder: NSCoder) { /* 661 */
        fatalError() /* 662 */
    }
    
    private func setUpLayer() { /* 967 */
        contentView.layer.cornerRadius = 8 /* 968 */
        contentView.layer.borderWidth = 2 /* 968 */
    }
    
    private func setUpConstraints() { /* 663 */
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor), /* 876 */
            seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10), /* 876 */
            seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10), /* 876 */
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3), /* 876 */
            
            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor), /* 877 */
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10), /* 877 */
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10), /* 877 */
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3), /* 877 */
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor), /* 878 */
            airDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10), /* 878 */
            airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10), /* 878 */
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3), /* 878 */
        ])
    }
    
    override func prepareForReuse() { /* 664 prepareForReuse */
        super.prepareForReuse() /* 665 */
        seasonLabel.text = nil /* 870 */
        nameLabel.text = nil /* 870 */
        airDateLabel.text = nil /* 870 */
    }
    
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) { /* 658  */
        viewModel.registerForData { [weak self] data in /* 857 */ /* 871 add weak self */
//            print(String(describing: data)) /* 858 */
            //Main Queue
//            print(data.name) /* 860 */
//            print(data.air_date) /* 861 */
//            print(data.episode) /* 862 */
            self?.nameLabel.text = data.name /* 872 */
            self?.seasonLabel.text = "Episode "+data.episode /* 873 */
            self?.airDateLabel.text = "Aired on "+data.air_date /* 874 */
        }
        viewModel.fetchEpisode() /* 827 */
        contentView.layer.borderColor = viewModel.borderColor.cgColor /* 973 */
    }
}
