//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 06.04.2023.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject { /* 1992 */
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) /* 1993 */
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int) /* 2188 */
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int) /* 2189 */

}

/// Shows search results UI (table or collection as needed)
final class RMSearchResultsView: UIView { /* 1916 add final */

    weak var delegate: RMSearchResultsViewDelegate? /* 1994 */
    
    private var viewModel: RMSearchResultViewModel? { /* 1926 */ /* 2122 change RMSearchResultType to RMSearchResultViewModel */
        didSet { /* 1927 */
            self.processViewModel() /* 1928 */
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView() /* 1965 */
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier) /* 1966 */
        table.isHidden = true /* 1967 */
        table.translatesAutoresizingMaskIntoConstraints = false /* 1968 */
        return table /* 1969 */
    }() /* 1964 */
    
    private let collectionView: UICollectionView = { /* 2015 copy from RMCgaracterListView and rewrite */
        let layout = UICollectionViewFlowLayout() /* 2015 */
        layout.scrollDirection = .vertical /* 2015 */
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) /* 2015 */
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) /* 2015 */
        collectionView.isHidden = true /* 2015 */
        collectionView.translatesAutoresizingMaskIntoConstraints = false /* 2015 */
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier) /* 2015 */
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier) /* 2015 */
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier) /* 2015 */
        //Footer for loading
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier) /* 2159 */
       
        return collectionView /* 2015 */
    }()
    
    /// TableView viewModels
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = [] /* 1981 */
    
    /// CollectionView ViewModels
    private var collectionViewCellViewModels: [any Hashable] = [] /* 2033 */
    
    //MARK: - Init
    
    override init(frame: CGRect) { /* 1917 */
        super.init(frame: frame) /* 1918 */
        isHidden = true /* 1919 */
        translatesAutoresizingMaskIntoConstraints = false /* 1920 */
//        backgroundColor = .red /* 1921 */
        addSubviews(tableView, collectionView) /* 1970 */ /* 2016 add collectionView */
        addConstraints() /* 1958 */
    }
    
    required init?(coder: NSCoder) { /* 1922 */
        fatalError() /* 1923 */
    }
    
    private func processViewModel() { /* 1929 */
        guard let viewModel = viewModel else { /* 1930 */
            return /* 1931 */
        }
        
        switch viewModel.results { /* 1932 */ /* 2123 add .results */
        case .characters(let viewModels): /* 1933 */
            self.collectionViewCellViewModels = viewModels /* 2031 */
            setUpCollectionView() /* 1962 */
        case .locations(let viewModels): /* 1934 */
            setUpTableView(viewModels: viewModels) /* 1963 */ /* 1978 add viewModels */
        case .episodes(let viewModels): /* 1934 */
            self.collectionViewCellViewModels = viewModels /* 2032 */
            setUpCollectionView() /* 1961 */
        }
    }
    
    private func setUpCollectionView() { /* 1959 */
        self.tableView.isHidden = true /* 2019 */
        self.collectionView.isHidden = false /* 2019 */
//        collectionView.backgroundColor = .red /* 2021 */
        collectionView.delegate = self /* 2022 */
        collectionView.dataSource = self /* 2023 */
        collectionView.reloadData() /* 2017 */
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]) { /* 1960 */ /* 1980 add viewModels */
        tableView.delegate = self /* 1976 */
        tableView.dataSource = self /* 1977 */
        tableView.isHidden = false /* 1975 */
        collectionView.isHidden = true /* 2020 */
        self.locationCellViewModels = viewModels /* 1979 */
        tableView.reloadData() /* 1991 */
    }
    
    private func addConstraints() { /* 1924 */
        NSLayoutConstraint.activate([ /* 1971 */
            tableView.topAnchor.constraint(equalTo: topAnchor), /* 1972 */
            tableView.leftAnchor.constraint(equalTo: leftAnchor), /* 1972 */
            tableView.rightAnchor.constraint(equalTo: rightAnchor), /* 1972 */
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor), /* 1972 */
            
            collectionView.topAnchor.constraint(equalTo: topAnchor), /* 2018 */
            collectionView.leftAnchor.constraint(equalTo: leftAnchor), /* 2018 */
            collectionView.rightAnchor.constraint(equalTo: rightAnchor), /* 2018 */
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor), /* 2018 */
        ])
//        tableView.backgroundColor = .yellow /* 1973 */
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) { /* 1925 */ /* 2121 change RMSearchResultType to RMSearchResultViewModel */
        self.viewModel = viewModel  /* 1974 */
    }
}

//MARK: - TableView

extension RMSearchResultsView: UITableViewDataSource, UITableViewDelegate { /* 1982 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 1983 numberOfRowsInSection */
        return locationCellViewModels.count /* 1984 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 1985 cellForRow */
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier,
                                                       for: indexPath) as? RMLocationTableViewCell else {
            fatalError("Failed to dequeue RMLocationTableViewCell") /* 1986 */
        }
        cell.configure(with: locationCellViewModels[indexPath.row]) /* 1987 */
        return cell /* 1988 */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 1989 */
        tableView.deselectRow(at: indexPath, animated: true) /* 1990 */
        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row) /* 1995 */
    }
}

//MARK: - CollectionView

extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout { /* 2023 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 2024 numberOfItems */
        return collectionViewCellViewModels.count /* 2034 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 2025 cellForItem */
//        fatalError("") /* 2026 */
        let currentViewModel = collectionViewCellViewModels[indexPath.row] /* 2035 */
        if let characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel { /* 2036 */
            //dequeue character cell
            guard let cell = collectionView.dequeueReusableCell( /* 2037 */
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else { /* 2038 */
                fatalError() /* 2039 */
            }

            cell.configure(with: characterVM) /* 2045 */
            return cell /* 2040 */
        }
        
        //dequeue Episode
        guard let cell = collectionView.dequeueReusableCell( /* 2041 */
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterEpisodeCollectionViewCell else { /* 2042 */
            fatalError() /* 2043 */
        }
        if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel { /* 2046 */
            cell.configure(with: episodeVM) /* 2047 */
        }
        return cell /* 2044 */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 2027 didSelect */
        collectionView.deselectItem(at: indexPath, animated: true) /* 2028 */
        //Handle cell tap
        guard let viewModel = viewModel else { /* 2190 copy from 1930 and paste */
            return /* 2190 */
        }
        
        switch viewModel.results { /* 2190 */
        case .characters: /* 2190 */
            delegate?.rmSearchResultsView(self, didTapCharacterAt: indexPath.row) /* 2192 */
        case .episodes: /* 2190 */
            delegate?.rmSearchResultsView(self, didTapEpisodeAt: indexPath.row) /* 2193 */
        case .locations: /* 2190 */
            break /* 2191 */ /* */
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { /* 2029 sizeForItem */
        let currentViewModel = collectionViewCellViewModels[indexPath.row] /* 2048 */
        
        let bounds = collectionView.bounds /* 2052 */
        
        if currentViewModel is RMCharacterCollectionViewCellViewModel { /* 2049 */
            //Character size
            let width = UIDevice.isiPhone ? (bounds.width-30)/2 : (bounds.width-50)/4 /* 2050 copy from 209 and paste */ /* 2186 add UIDevice.isiPhone */
            return CGSize(
                width: width,
                height: width * 1.5
            ) /* 2050 */
        }
        
        //Episode
//        return CGSize(width: 100, height: 100) /* 2030 */
        let width = UIDevice.isiPhone ? bounds.width-20 : (bounds.width-50)/4 /* 2051 copy from 957 and paste */ /* 2187 add UIDevice.isiPhone */
        return CGSize(
            width: width,
            height: 100
        ) /* 2057 */
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView { /* 2160 copy from RMCharacterListViewViewModel (386) */
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView( /* 2160 */
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView /* 2160 */
                 else {
            fatalError("Unsupported") /* 2160 */
        }
        if let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicatior { /* 2161 */
            footer.startAnimating() /* 2160 */
        }
        return footer /* 2160 */
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize { /* 2160 */
        guard let viewModel = viewModel,
              viewModel.shouldShowLoadMoreIndicatior else { /* 2160 */
            return .zero /* 2160 */
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100) /* 2160 */
    }
    
}

//MARK: - ScrollViewDelegate

extension RMSearchResultsView: UIScrollViewDelegate { /* 2111 copy from 2058 and paste */
    func scrollViewDidScroll(_ scrollView: UIScrollView) { /* 2111 */
        if !locationCellViewModels.isEmpty { /* 2155 */
            handleLocationPagination(scrollView: scrollView) /* 2154 */
        } else { /* 2156 */
            //CollectionView
            handleCharacterOrEpisodePagination(scrollView: scrollView) /* 2158 */
        }
    }
    
    private func handleCharacterOrEpisodePagination(scrollView: UIScrollView) { /* 2157 */
        guard let viewModel = viewModel,
              !collectionViewCellViewModels.isEmpty, /* 2163 */
              viewModel.shouldShowLoadMoreIndicatior,
              !viewModel.isLoadingMoreResults else { /* 2162 copy from 2152  */
            return /* 2162 */
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in /* 2162 */
            let offset = scrollView.contentOffset.y /* 2162 */
            let totalContentHeight = scrollView.contentSize.height /* 2162 */
            let totalScrollViewFixedHeight = scrollView.frame.size.height /* 2162 */
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) { /* 2162 */
                viewModel.fetchAdditionalResults { [weak self] newResults in /* 2162 */
                    //Refresh table
                    guard let strongSelf = self else { /* 2170 */
                        return /* 2171 */
                    }
                    
                    DispatchQueue.main.async { /* 2173 */
                        strongSelf.tableView.tableFooterView = nil /* 2162 */
                        
                        let originalCount = strongSelf.collectionViewCellViewModels.count /* 2169 copy from 445 */
                        let newCount = (newResults.count - originalCount) /* 2169 */
                        let total = originalCount + newCount /* 2169 */
                        let startingIndex = total - newCount /* 2169 */
                        let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({ /* 2169 */
                            return IndexPath(row: $0, section: 0) /* 2169 */
                        })
//                        print("Should add more result cells for search results: \(newResults.count)") /* 2164 */
                        strongSelf.collectionViewCellViewModels = newResults /* 2162 */
                        strongSelf.collectionView.insertItems(at: indexPathsToAdd) /* 2172 */
                    }
                } /* 2162 */
            }
            t.invalidate() /* 2162 */
        }
    }
    
    private func handleLocationPagination(scrollView: UIScrollView) { /* 2152 */ /* 2153 add parameters */
        guard let viewModel = viewModel,
              !locationCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicatior,
              !viewModel.isLoadingMoreResults else { /* 2111 */ /* 2130 add !locationCellViewModels */ /* 2131 add shouldShow */
            return /* 2111 */
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in /* 2111 */
            let offset = scrollView.contentOffset.y /* 2111 */
            let totalContentHeight = scrollView.contentSize.height /* 2111 */
            let totalScrollViewFixedHeight = scrollView.frame.size.height /* 2111 */
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) { /* 2111 */
                DispatchQueue.main.async { /* 2111 */
                    self?.showTableLoadingIndicator() /* 2111 */
                }
                viewModel.fetchAdditionalLocations { [weak self] newResults in /* 2144 add completion and press enter , add weak self */
                    //Refresh table
                    self?.tableView.tableFooterView = nil /* 2145 */
                    self?.locationCellViewModels = newResults /* 2148 */
                    self?.tableView.reloadData() /* 2146 */
                } /* 2111 */
            }
            t.invalidate() /* 2111 */
        }
    }
    
            private func showTableLoadingIndicator() { /* 2111 */
                let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100)) /* 2111 */
                    tableView.tableFooterView = footer /* 2111 */

    }
}
