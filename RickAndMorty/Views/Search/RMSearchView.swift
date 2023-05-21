//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 02.04.2023.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject { /* 1720 */
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) /* 1721 */
    
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) /* 2008 */
    func rmSearchView(_ searchView: RMSearchView, didSelectCharacter character: RMCharacter) /* 2197 */
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode) /* 2205 */
}

final class RMSearchView: UIView { /* 1536 add final */
    
    weak var delegate: RMSearchViewDelegate? /* 1722 */
    
    private let viewModel: RMSearchViewViewModel /* 1547 */
    
    //MARK: - Subviews
    
    //SearchInputView(bar, selection buttons)
    private let searchInputView = RMSearchInputView() /* 1625 */
    //No results view
    private let noResultsView = RMNoSearchResultsView() /* 1593 */
    //Results collectionView
    private let resultsView = RMSearchResultsView() /* 1935 */
    
    //MARK: - Init
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) { /* 1537 */
        self.viewModel = viewModel /* 1548 */
        super.init(frame: frame) /* 1538 */
//        backgroundColor = .red /* 1539 */
        backgroundColor = .systemBackground /* 1611 */
        translatesAutoresizingMaskIntoConstraints = false /* 1540 */
        addSubviews(resultsView ,noResultsView, searchInputView) /* 1594 */ /* 1626 add searchInputView */ /* 1936 add resultsView */
        addConstraints() /* 1596 */
        
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type)) /* 1665 */
        searchInputView.delegate = self /* 1717 */
        
        setUpHandlers(viewModel: viewModel) /* 1947 */
        
        resultsView.delegate = self /* 1999 */
    }
    
    required init?(coder: NSCoder) { /* 1541 */
        fatalError() /* 1542 */
    }

    private func setUpHandlers(viewModel: RMSearchViewViewModel) { /* 1946 */
        viewModel.registerOptionChangeBlock { tuple in /* 1782 */
            //tuple: Option | newValue
//            print(String(describing: tuple)) /* 1788 */
            self.searchInputView.update(option: tuple.0, value: tuple.1) /* 1794 */
        }

        viewModel.registerSearchResultHandler { [weak self] result in /* 1867 */ /* 1905 add results in */ /* 1957 add weak self */ /* 2119 change results to result */
//            print(results) /* 1906 */
            DispatchQueue.main.async { /* 1953 */
                self?.resultsView.configure(with: result) /* 1956 */ /* 2120 change results to result */
                self?.noResultsView.isHidden = true /* 1954 */
                self?.resultsView.isHidden = false /* 1955 */
            }
        }
        
        viewModel.registerNoResultsHandler { [weak self] in /* 1948 */ /* 1952 add weak self */
            DispatchQueue.main.async { /* 1949 */
                self?.noResultsView.isHidden = false /* 1950 */
                self?.resultsView.isHidden = true /* 1951 */
            }
        }
    }
    
    private func addConstraints() { /* 1595 */
        NSLayoutConstraint.activate([ /* 1597 */
            //Search input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor), /* 1627 */
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor), /* 1627 */
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor), /* 1627 */
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110), /* 1627 */ /* 1667 change from 110 */
            
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor), /* 1937 */
            resultsView.leftAnchor.constraint(equalTo: leftAnchor), /* 1937 */
            resultsView.rightAnchor.constraint(equalTo: rightAnchor), /* 1937 */
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor), /* 1937 */
            
            //No results
            noResultsView.widthAnchor.constraint(equalToConstant: 150), /* 1598 */
            noResultsView.heightAnchor.constraint(equalToConstant: 150), /* 1598 */
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor), /* 1598 */
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor), /* 1598 */
        ])
    }
    
    public func presentKeyboard() { /* 1668 */
        searchInputView.presentKeyboard() /* 1674 */
    }
}

//MARK: - CollectionView

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource { /* 1549 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 1550 numberOfItems */
        return 0 /* 1551 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 1552 */
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) /* 1553 */
        return cell /* 1554 */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 1555 */
        collectionView.deselectItem(at: indexPath, animated: true) /* 1556 */
        
        
    }
}

//MARK: - RMSearchInputViewDelegate

extension RMSearchView: RMSearchInputViewDelegate { /* 1718 */
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) { /* 1719 */
        delegate?.rmSearchView(self, didSelectOption: option) /* 1723 */
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) { /* 1858 didChangeSearchText */
        viewModel.set(query: text) /* 1864 */
    }
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) { /* 1861 rmSearchInputViewDidTapSearchKeyboardButton */
        viewModel.executeSearch() /* 1862 */
    }
}

//MARK: - RMSearchResultsViewDelegate

extension RMSearchView: RMSearchResultsViewDelegate { /* 1996 */
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) { /* 1997 rmSearch */
        guard let locationModel = viewModel.locationSearchResult(at: index) else { /* 2002 */
            return /* 2007 */
        }
//        print("Location tapped: \(locationModel)") /* 1998 */
        delegate?.rmSearchView(self, didSelectLocation: locationModel) /* 2009 */
    }
    
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int) { /* 2194 */
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else { /* 2203 copy from 2196  */
            return /* 2203 */
        }
        delegate?.rmSearchView(self, didSelectEpisode: episodeModel) /* 2203 */
    }
    
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int) { /* 2195 */
        guard let characterModel = viewModel.characterSearchResult(at: index) else { /* 2196 */
            return /* 2196 */
        }
        delegate?.rmSearchView(self, didSelectCharacter: characterModel) /* 2196 copy from 2009 and paste */
    }
}
