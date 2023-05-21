//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 16.03.2023.
//

import UIKit

/// Single cell for a character
final class RMCharacterCollectionViewCell: UICollectionViewCell { /* 213 */
    static let cellIdentifier = "RMCharacterCollectionViewCell" /* 214 */
    
    private let imageView: UIImageView = { /* 226 */
        let imageView = UIImageView() /* 227 */
        imageView.contentMode = .scaleAspectFill /* 228 */
        imageView.clipsToBounds = true /* 330 says: dont overflow */
        imageView.translatesAutoresizingMaskIntoConstraints = false /* 229 */
        return imageView /* 230 */
    }()
    
    private let nameLabel: UILabel = { /* 231 */
        let label = UILabel() /* 232 */
        label.textColor = .label /* 236 */
        label.font = .systemFont(ofSize: 18, weight: .medium) /* 233 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 234 */
        return label /* 235 */
    }()
    
    private let statusLabel: UILabel = { /* 237 */
        let label = UILabel() /* 238 */
        label.textColor = .secondaryLabel /* 239 */
        label.font = .systemFont(ofSize: 16, weight: .regular) /* 240 */
        label.translatesAutoresizingMaskIntoConstraints = false /* 241 */
        return label /* 242 */
    }()
    
    
    //MARK: - Init
    
    override init(frame: CGRect) { /* 215 init */
        super.init(frame: frame) /* 216 */
        contentView.backgroundColor = .secondarySystemBackground /* 217 */
        contentView.addSubviews(imageView, nameLabel, statusLabel) /* 243 */
        addConstraint() /* 247 */
        setUpLayer() /* 332 */
    }
    
    required init?(coder: NSCoder) { /* 218 */
        fatalError("Unsupported")
    }
    
    private func setUpLayer() { /* 331 */
        contentView.layer.cornerRadius = 8 /* 325 */
        contentView.layer.shadowColor = UIColor.label.cgColor /* 326 */
        contentView.layer.cornerRadius = 4 /* 327 */
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4) /* 329 */
        contentView.layer.shadowOpacity = 0.3 /* 328 */
    }
    private func addConstraint() { /* 219 */
        NSLayoutConstraint.activate([ /* 248 */
            statusLabel.heightAnchor.constraint(equalToConstant: 30), /* 275 */
            nameLabel.heightAnchor.constraint(equalToConstant: 30), /* 276 */
            
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7), /* 277 */
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7), /* 278 */
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7), /* 279 */
            nameLabel.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -7), /* 280 */
        
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3), /* 281 */
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor), /* 282 */
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor), /* 285 */
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor), /* 286 */
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor), /* 287 */
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3), /* 288 */
        ])
        
        //imageView.backgroundColor = .systemGreen /* 289 */
        //nameLabel.backgroundColor = .red /* 283 */
        //statusLabel.backgroundColor = .orange /* 284 */
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { /* 333 traitCollectionDidChange */
        super.traitCollectionDidChange(previousTraitCollection) /* 334 */
        setUpLayer() /* 335 */
    }
    
    override func prepareForReuse() { /* 220 prepareForReuse */
        super.prepareForReuse() /* 221 */
        imageView.image = nil /* 244 */
        nameLabel.text = nil /* 245 */
        statusLabel.text = nil /* 246 */
    }
    
    public func configure(with viewModel: RMCharacterCollectionViewCellViewModel) { /* 222 */
        nameLabel.text = viewModel.characterName /* 290 */
        statusLabel.text = viewModel.characterStatusText /* 291 */
        viewModel.fetchImage { [weak self] result in /* 292 weak self - capture pointer to self in a weak capacity*/
            switch result { /* 293 */
            case .success(let data): /* 294 */
                DispatchQueue.main.async { /* 295 */
                    let image = UIImage(data: data) /* 296 */
                    self?.imageView.image = image /* 297 */
                }
            case .failure(let error): /* 298 */
                print(String(describing: error)) /* 300 */
                break /* 299 */
            }
        }
    }
}
