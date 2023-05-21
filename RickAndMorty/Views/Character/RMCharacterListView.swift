//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 16.03.2023.
//

import UIKit

protocol RMCharacterListViewDelegate: AnyObject { /* 341 */
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) /* 343 */
    
}
/// View that handles showing list of characters, loader,etc.
final class RMCharacterListView: UIView { /* 145 */
    
    public weak var delegate: RMCharacterListViewDelegate? /* 342 */
    
    private let viewModel = RMCharacterListViewViewModel() /* 156 */
    
    private let spinner: UIActivityIndicatorView = { /* 157 */
        let spinner = UIActivityIndicatorView(style: .large) /* 158 */
        spinner.hidesWhenStopped = true /* 160 */
        spinner.translatesAutoresizingMaskIntoConstraints = false /* 161 we will want ob any view we want to use with auto layout*/
        return spinner /* 159 */
    }()
    
    private let collectionView: UICollectionView = { /* 170 */
        let layout = UICollectionViewFlowLayout() /* 171 */
        layout.scrollDirection = .vertical /* 209 */
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10) /* 210 */
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) /* 173 */
        collectionView.isHidden = true /* 176 */
        collectionView.alpha = 0 /* 177 */
        collectionView.translatesAutoresizingMaskIntoConstraints = false /* 174 */
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier) /* 175 to register a cell to show for each of the grid */ /* 224 replace UICollectionViewCell with RMCharacterCollectionViewCell and "cell" */
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier) /* 385 means: we register a footer that we can show up */
        return collectionView /* 172 */
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) { /* 146 */
        super.init(frame: frame) /* 147 */
        translatesAutoresizingMaskIntoConstraints = false /* 148 */
        //backgroundColor = .systemBlue /* 151 */
        //addSubview(spinner) /* 162 */
        addSubviews(collectionView, spinner) /* 183 */
        addConstraint() /* 167 */
        spinner.startAnimating() /* 168 */
        viewModel.delegate = self /* 314 */
        viewModel.fetchCharacters() /* 169 to kick off the request to go and get data, to recall in CharacterListViewViewModel use fetchCharacter() */
        setUpCollectionView() /* */
    }

    required init?(coder: NSCoder) { /* 149 */
        fatalError("Unsupported") /* 150 */
    }
    
    private func addConstraint() { /* 163 */
        NSLayoutConstraint.activate([ /* 164 */
            spinner.widthAnchor.constraint(equalToConstant: 100), /* 165 */
            spinner.heightAnchor.constraint(equalToConstant: 100), /* 165 */
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor), /* 166 */
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor), /* 166 */
            
            collectionView.topAnchor.constraint(equalTo: topAnchor), /* 184 */
            collectionView.leftAnchor.constraint(equalTo: leftAnchor), /* 184 */
            collectionView.rightAnchor.constraint(equalTo: rightAnchor), /* 184 */
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor) /* 184 */
        ])
    }
    
    private func setUpCollectionView() { /* 185 */
        collectionView.dataSource = viewModel /* 196 */
        collectionView.delegate = viewModel /* 202 */
        /*
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: { /* 197 this says after 2 secs go ahead and get rid of the spinner and show the collection view*/
            self.spinner.stopAnimating() /* 198 */
            self.collectionView.isHidden = false /* 199 */
            UIView.animate(withDuration: 0.4) { /* 200 to animate alpha, will be fading */
                self.collectionView.alpha = 1 /* 201 alpha = opacity */
            }
        })
         */
    }
}

extension RMCharacterListView: RMCharacterListViewViewModelDelegate { /* 320 */
    func didSelectCharacter(_ character: RMCharacter) { /* 340 */
        delegate?.rmCharacterListView(self, didSelectCharacter: character) /* 344 */
    }
    func didLoadInitialCharacters() { /* 321 */
        spinner.stopAnimating() /* 323 replace drom setUpCollectionView */
        collectionView.isHidden = false /* 323 */
        collectionView.reloadData() /* 322 */ //Initial fetch
        UIView.animate(withDuration: 0.4) { /* 323 */
            self.collectionView.alpha = 1 /* 323 */
        }
    }
    
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) { /* 450 didLoadMore... */
         
        collectionView.performBatchUpdates { /* 451 want to tell collectionView to add more cells */
            self.collectionView.insertItems(at: newIndexPaths) /* 452 to insert items */
        }
    }
}
