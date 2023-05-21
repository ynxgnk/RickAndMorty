//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 22.03.2023.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell { /* 640 add final */
    static let cellIdentifier = "RMCharacterPhotoCollectionViewCell" /* 641 */
    
    private let imageView: UIImageView = { /* 681 */
        let imageView = UIImageView() /* 681 */
        imageView.contentMode = .scaleAspectFill /* 681 */
        imageView.clipsToBounds = true /* 681 */
        imageView.translatesAutoresizingMaskIntoConstraints = false /* 681 */
        return imageView /* 681 */
    }() /* 681 copy from RMCharacterCollectionViewCell imageView and paste */
    
    override init(frame: CGRect) { /* 659 */
        super.init(frame: frame) /* 660 */
        contentView.addSubview(imageView) /* 682 */
        setUpConstraints() /* 683 */
    }
    
    required init?(coder: NSCoder) { /* 661 */
        fatalError() /* 662 */
    }
    
    private func setUpConstraints() { /* 663 */
        NSLayoutConstraint.activate([ /* 684 */
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor), /* 685 */
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor), /* 685 */
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor), /* 685 */
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor), /* 685 */
        ])
    }
    
    override func prepareForReuse() { /* 664 prepareForReuse */
        super.prepareForReuse() /* 665 */
        imageView.image = nil /* 686 */
    }
    
    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) { /* 658  */
        viewModel.fetchImage { [weak self] result in
            switch result { /* 692 */
            case .success(let data): /* 693 */
                DispatchQueue.main.async { /* 697 to bump to the main queue EI the main thread where we hould do all out data operations  (not to leak any memory) */
                    self?.imageView.image = UIImage(data: data) /* 694 */
                }
            case .failure: /* 695 */
                break /* 696 */
            }
        } /* 691 */
    }
}
