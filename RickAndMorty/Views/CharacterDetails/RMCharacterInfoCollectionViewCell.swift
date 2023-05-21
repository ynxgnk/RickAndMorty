//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 22.03.2023.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell { /* 700 add final */
    static let cellIdentifier = "RMCharacterInfoCollectionViewCell" /* 642 */
    
    private let valueLabel: UILabel = { /* 701 */
        let label = UILabel() /* 702 */
        label.numberOfLines = 0 /* 815 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 703 */
//        label.text = "Earth" /* 713 */
        label.font = .systemFont(ofSize: 22, weight: .light) /* 734 */
        return label /* 704 */
    }()
    
    private let titleLabel: UILabel = { /* 705  */
        let label = UILabel() /* 706 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 707 */
        label.textAlignment = .center /* 729 */
        label.font = .systemFont(ofSize: 20, weight: .medium) /* 730 */
//        label.text = "Location" /* 714 */
        return label /* 708 */
    }()
    
    private let iconImageView: UIImageView = { /* 709 */
        let icon = UIImageView() /* 710 */
        icon.translatesAutoresizingMaskIntoConstraints = false /* 711 */
//        icon.image = UIImage(systemName: "globe.americas") /* 715 */
        icon.contentMode = .scaleAspectFit /* 731 */
        return icon /* 712 */
    }()
    
    private let titleContainerView: UIView = { /* 720 */
        let view = UIView() /* 721 */
        view.translatesAutoresizingMaskIntoConstraints = false /* 722 */
        view.backgroundColor = .secondarySystemBackground /* 725 */
        return view /* 723 */
    }()
    
    //MARK: -Init
    
    override init(frame: CGRect) { /* 659 */
        super.init(frame: frame) /* 660 */
        contentView.backgroundColor = .tertiarySystemBackground /* 698 */
        contentView.layer.cornerRadius = 8 /* 699 */
        contentView.layer.masksToBounds = true /* 732 */
        contentView.addSubviews(titleContainerView,valueLabel,iconImageView) /* 716 */
        titleContainerView.addSubview(titleLabel) /* 724 */
        setUpConstraints() /* 717 */
    }
    
    required init?(coder: NSCoder) { /* 661 */
        fatalError() /* 662 */
    }
    
    private func setUpConstraints() { /* 663 */
        NSLayoutConstraint.activate([ /* 718 */
            titleContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor), /* 726  */
            titleContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor), /* 726  */
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor), /* 726  */
            titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33), /* 727 */
            
            titleLabel.leftAnchor.constraint(equalTo: titleContainerView.leftAnchor), /* 728 */
            titleLabel.rightAnchor.constraint(equalTo: titleContainerView.rightAnchor), /* 728 */
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor), /* 728 */
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor), /* 728 */
            
            iconImageView.heightAnchor.constraint(equalToConstant: 30), /* 729 */
            iconImageView.widthAnchor.constraint(equalToConstant: 30), /* 729 */
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35), /* 729 */
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20), /* 729 */
//            iconImageView.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: -10), /* 729 */
            
            valueLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10), /* 730 */
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10), /* 730 */
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor), /* 730 */ /* 816 remove constant: 35 */
//            valueLabel.heightAnchor.constraint(equalToConstant: 30) /* 730 */
            valueLabel.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor) /* 817 */
        ])
        //valueLabel.backgroundColor = .red /* 733 */
    }
    
    override func prepareForReuse() { /* 664 prepareForReuse */
        super.prepareForReuse() /* 665 */
        valueLabel.text = nil /* 719 */
        titleLabel.text = nil /* 719 */
        iconImageView.image = nil /* 719 */
        iconImageView.tintColor = .label /* 786 */
        titleLabel.textColor = .label /* 787 */
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) { /* 658  */
        titleLabel.text = viewModel.title /* 735 */
        valueLabel.text = viewModel.displayValue /* 736 */ /* 780 change .value to .displayValue */
        iconImageView.image = viewModel.iconImage /* 781 */
        iconImageView.tintColor = viewModel.tintColor /* 782 */
        titleLabel.textColor = viewModel.tintColor /* 785 */
    }
    
}
