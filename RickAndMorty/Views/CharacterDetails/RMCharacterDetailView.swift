//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 19.03.2023.
//

import UIKit

///View for single character info
final class RMCharacterDetailView: UIView { /* 507 */
    
    public var collectionView: UICollectionView? /* 544 */ /* 572 remove private */
    
    private let viewModel: RMCharacterDetailViewViewModel /* 581 */
    
    private let spinner: UIActivityIndicatorView = { /* 545 copy and paste from RMCharacterListView */
        let spinner = UIActivityIndicatorView(style: .large) /* 545 */
        spinner.hidesWhenStopped = true /* 545 */
        spinner.translatesAutoresizingMaskIntoConstraints = false /* 545 */
        return spinner /* 545 */
    }()
    
    //MARK: - Init
    
    init(frame: CGRect, viewModel: RMCharacterDetailViewViewModel) { /* 508 */ /* 580 delete override and add viewModel: RMCharacter... */
        self.viewModel = viewModel /* 582 */
        super.init(frame: frame) /* 509 */
        translatesAutoresizingMaskIntoConstraints = false /* 513 */
        backgroundColor = .systemBackground /* 510 */ /* 575 replace .systemPurple */
        let collectionView = createCollectionView() /* 547 */
        self.collectionView = collectionView /* 548 */
        addSubviews(collectionView, spinner) /* 549 */
        addConstraints() /* 546 */
    }
    
    required init?(coder: NSCoder) { /* 511 */
        fatalError("Unsupported") /* 512 */
    }

    private func addConstraints() { /* 542 */
        guard let collectionView = collectionView else { /* 551 */
            return /* 552 */
        }
        NSLayoutConstraint.activate([ /* 550 copy and paste from RMCharacterListView */
            spinner.widthAnchor.constraint(equalToConstant: 100), /* 550 */
            spinner.heightAnchor.constraint(equalToConstant: 100), /* 550 */
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor), /* 550 */
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor), /* 550 */
            
            collectionView.topAnchor.constraint(equalTo: topAnchor), /* 550 */
            collectionView.leftAnchor.constraint(equalTo: leftAnchor), /* 550 */
            collectionView.rightAnchor.constraint(equalTo: rightAnchor), /* 550 */
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor) /* 550 */
        ])
    }
    
    private func createCollectionView() -> UICollectionView { /* 543 */
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in /* 556 */
            return self.createSection(for: sectionIndex) /* 557 */
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) /* 553 */
        collectionView.register(RMCharacterPhotoCollectionViewCell.self, /* 644 replace UICollectionViewCell with RMCharacter...*/
                                forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier) /* 555 */ /* 645 replace "cell" with RM....cellIdentifier */
        collectionView.register(RMCharacterInfoCollectionViewCell.self, /* 646 */
                                forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, /* 647 */
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false /* 568 */
        return collectionView /* 554 */
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection { /* 558 */
        let sectionTypes = viewModel.sections /* 584 */
        switch sectionTypes[sectionIndex] { /* 585 */
        case .photo: /* 586 */
            return viewModel.createPhotoSectionLayout() /* 592 */
        case .information: /* 586 */
            return viewModel.createInfoSectionLayout() /* 593 */
        case .episodes: /* 586 */
            return viewModel.createEpisodeSectionLayout() /* 594 */
        }
    }
}
