//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 26.03.2023.
//

import UIKit /* 950 copy whole file from RMCharacterListView and than remove what dont need */

protocol RMEpisodeListViewDelegate: AnyObject { /* 950 */
    func rmEpisodeListView(
        _ characterListView: RMEpisodeListView,
        didSelectEpisode episode: RMEpisode) /* 950 change to episode */
    
}
/// View that handles showing list of episodes, loader,etc.
final class RMEpisodeListView: UIView { /* 950 change to episode */
    
    public weak var delegate: RMEpisodeListViewDelegate? /* 950 */
    
    private let viewModel = RMEpisodeListViewViewModel() /* 950 */
    
    private let spinner: UIActivityIndicatorView = { /* 950 */
        let spinner = UIActivityIndicatorView(style: .large) /* 950 */
        spinner.hidesWhenStopped = true /* 950 */
        spinner.translatesAutoresizingMaskIntoConstraints = false /* 950 we will want ob any view we want to use with auto layout*/
        return spinner /* 950 */
    }()
    
    private let collectionView: UICollectionView = { /* 950 */
        let layout = UICollectionViewFlowLayout() /* 950 */
        layout.scrollDirection = .vertical /* 950 */
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10) /* 950 */
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) /* 950 */
        collectionView.isHidden = true /* 950 */
        collectionView.alpha = 0 /* 950 */
        collectionView.translatesAutoresizingMaskIntoConstraints = false /* 950 */
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier) /* 950 to register a cell to show for each of the grid */
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier) /* 950 means: we register a footer that we can show up */
        return collectionView /* 950 */
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) { /* 950 */
        super.init(frame: frame) /* 950 */
        translatesAutoresizingMaskIntoConstraints = false /* 950 */
        addSubviews(collectionView, spinner) /* 950 */
        addConstraints() /* 950 */
        spinner.startAnimating() /* 950 */
        viewModel.delegate = self /* 950 */
        viewModel.fetchEpisodes() /* 950 to kick off the request to go and get data, to recall in CharacterListViewViewModel use fetchCharacter() */
        setUpCollectionView() /* 950 */
    }

    required init?(coder: NSCoder) { /* 950 */
        fatalError("Unsupported") /* 950 */
    }
    
    private func addConstraints() { /* 950 */
        NSLayoutConstraint.activate([ /* 950 */
            spinner.widthAnchor.constraint(equalToConstant: 100), /* 950 */
            spinner.heightAnchor.constraint(equalToConstant: 100), /* 950 */
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor), /* 950 */
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor), /* 950 */
            
            collectionView.topAnchor.constraint(equalTo: topAnchor), /* 950 */
            collectionView.leftAnchor.constraint(equalTo: leftAnchor), /* 950 */
            collectionView.rightAnchor.constraint(equalTo: rightAnchor), /* 950 */
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor) /* 950 */
        ])
    }
    
    private func setUpCollectionView() { /* 950 */
        collectionView.dataSource = viewModel /* 950 */
        collectionView.delegate = viewModel /* 950 */
    }
}

extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
    func didLoadInitialEpisodes() { /* 950 */
        spinner.stopAnimating() /* 950 */
        collectionView.isHidden = false /* 950 */
        collectionView.reloadData() /* 950 */ //Initial fetch
        UIView.animate(withDuration: 0.4) { /* 950 */
            self.collectionView.alpha = 1 /* 950 */
        }
    }
    
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) { /* 950 */
        collectionView.performBatchUpdates { /* 950 want to tell collectionView to add more cells */
            self.collectionView.insertItems(at: newIndexPaths) /* 950 to insert items */
        }
    }
    
    func didSelectEpisode(_ episode: RMEpisode) { /* 950 */
              delegate?.rmEpisodeListView(self, didSelectEpisode: episode) /* 950 */
    }
}


