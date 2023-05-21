//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 26.03.2023.
//
import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject { /* 957 copy whole file from RMCharacterListViewViewModel */
    func didLoadInitialEpisodes() /* 957 */
    
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath]) /* 957 */
    
    func didSelectEpisode(_ episode: RMEpisode)  /* 957 */
     

}

/// View Model to handle episode list view logic
final class RMEpisodeListViewViewModel: NSObject { /* 957 */
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate? /* 957 */
    
    private var isLoadingMoreCharacters = false /* 957 */
    
    private let borderColors: [UIColor] = [ /* 974 */
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemIndigo,
        .systemMint
    ]
    
    private var episodes: [RMEpisode] = [] { /* 957 */
       didSet { /* 957 means: whenever the value of characters is asigned, we want to do something */
           for episode in episodes { /* 957 */
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url), /* 975 pass in borderColor */
                    borderColor: borderColors.randomElement() ?? .systemBlue /* 976 */
                )
               if !cellViewModels.contains(viewModel) { /* 957 */
                   cellViewModels.append(viewModel) /* 957 */
               }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = [] /* 957 */
    
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil /* 957 */
    
    
    /// Fetch initial set of episodes (20)
    public func fetchEpisodes() {
        /* View that handles showing list of characters, loader, etc. */
        RMService.shared.execute(
            .listEpisodesRequest,
            expecting: RMGetAllEpisodesResponse.self) /* 957 */
        { [weak self] result in  /* 957 */
            
            switch result { /* 957 */
            case .success(let responseModel): /* 957 */
                let results = responseModel.results /* 957 */
                let info = responseModel.info /* 957 */
                self?.episodes = results /* 957 */
                self?.apiInfo = info /* 957 */
                DispatchQueue.main.async { /* 957 */
                    self?.delegate?.didLoadInitialEpisodes() /* 957 */
                }
            case .failure(let error): /* 957 */
                print(String(describing: error)) /* 957 */
            }
        }
    }
    
    /// Paginate if additional episodes are needed
    public func fetchAdditionalEpisodes(url: URL) {/* 957 */
        guard !isLoadingMoreCharacters else { /* 957 */
            return
        }
        
        isLoadingMoreCharacters = true /* 957 */
        guard let request = RMRequest(url: url) else { /* 957 */
            isLoadingMoreCharacters = false /* 957 */
            return /* 957 */
        }
        
        RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in /* 957 */
            guard let strongSelf = self else { /* 957 */
                return /* 957 */
            }
            switch result { /* 957 */
            case .success(let responseModel):
                let moreResults = responseModel.results /* 957 */
                let info = responseModel.info /* 957 */
                strongSelf.apiInfo = info /* 957 */
                
                let originalCount = strongSelf.episodes.count /* 957 */
                let newCount = moreResults.count /* 957 */
                let total = originalCount + newCount /* 957 */
                let startingIndex = total - newCount /* 957 */
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({ /* 957 compactMap - means to iterate over */
                    return IndexPath(row: $0, section: 0) /* 957 */
                })

                strongSelf.episodes.append(contentsOf: moreResults) /* 957 */

                DispatchQueue.main.async { /* 957 */
                    strongSelf.delegate?.didLoadMoreEpisodes(
                        with: indexPathsToAdd /* 957 */
                    ) /* 957  to tell the collcetionView that it needs to update in fact that theere are now new characters */
                    strongSelf.isLoadingMoreCharacters = false /* 957 */
                }
            case .failure(let failure):
                print(String(describing: failure)) /* 957 */
                self?.isLoadingMoreCharacters = false /* 957 */
            }
        }
        //Fetch characters
    }
    
    public var shouldShowLoadMoreIndicatior: Bool { /* 957 */
        return apiInfo?.next != nil /* 957 */
    }
}

//MARK: - CollectionView

extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout /* 957 */ {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 957 */
        return cellViewModels.count /* 957 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 957 */
        
        guard let cell = collectionView.dequeueReusableCell( /* 957 */
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, /* 957 */
            for: indexPath /* 957 */
        ) as? RMCharacterEpisodeCollectionViewCell else { /* 957 */
            fatalError("Unsupported cell") /* 957 */
        }
        cell.configure(with: cellViewModels[indexPath.row]) /* 957 */
        return cell /* 957 */
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView { /* 957 */
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView( /* 957 */
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView /* 404 */
                 else {
            fatalError("Unsupported") /* 957 */
        }
        footer.startAnimating() /* 957 */
        return footer /* 957 */
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize { /* 957 */
        guard shouldShowLoadMoreIndicatior else { /* 957 */
            return .zero /* 957 */
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100) /* 957 */
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { /* 957 */
        let bounds = /*UIScreen.main.bounds*/ collectionView.bounds /* 957 */ /* 966 change to collectionView.bounds */
        let width = bounds.width-20 /* 957 */ /* 965 change width */
        return CGSize(
            width: width,
            height: 100
        ) /* 957 */ /* 965 change height */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 957 */
        collectionView.deselectItem(at: indexPath, animated: true) /* 957 */
        let selection = episodes[indexPath.row] /* 957 */
        delegate?.didSelectEpisode(selection) /* 957 */
    }
}

//MARK: - ScrollView

extension RMEpisodeListViewViewModel: UIScrollViewDelegate { /* 957 */
    func scrollViewDidScroll(_ scrollView: UIScrollView) { /* 957 */
        guard shouldShowLoadMoreIndicatior,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty, /* 957 */
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else { /* 957 */
            return /* 957 */
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in /* 957 */
            let offset = scrollView.contentOffset.y /* 957 */
            let totalContentHeight = scrollView.contentSize.height /* 957 */
            let totalScrollViewFixedHeight = scrollView.frame.size.height /* 957 */
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) { /* 957 */
                self?.fetchAdditionalEpisodes(url: url) /* 957 */
            }
            t.invalidate() /* 957 */
        }
        
    }
}
