//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 16.03.2023.
//

import UIKit /* 187 import UIKit */

protocol RMCharacterListViewViewModelDelegate: AnyObject { /* 315 */
    func didLoadInitialCharacters() /* 316 */
    
    func didLoadMoreCharacters(with newIndexPath: [IndexPath]) /* 448 */ /* 453 update parameters */
    
    func didSelectCharacter(_ character: RMCharacter)  /* 339 */
     

}

/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject { /* 143 */ /* 188 add NSObject and change struct -> final class */
    
    public weak var delegate: RMCharacterListViewViewModelDelegate? /* 317 */
    
    private var isLoadingMoreCharacters = false /* 414 */
    
    private var characters: [RMCharacter] = [] { /* 303 */
       didSet { /* 304 means: whenever the value of characters is asigned, we want to do something */
//           print("Creating viewModels") /* 449 */
           for character in characters /* where !cellViewModels.contains(where: { $0.characterName == character.name }) */ { /* 304 */ /* 471 add where.. */ /* 489 rewrite for loop */
                let viewModel = RMCharacterCollectionViewCellViewModel( /* 304 */
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
               if !cellViewModels.contains(viewModel) { /* 490 */
                   cellViewModels.append(viewModel) /* 491 */
               }
//                cellViewModels.append(viewModel) /* 304 */
            }
        }
        
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = [] /* 306 */
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil /* 374 */
    
    
    /// Fetch initial set of characters (20)
    public func fetchCharacters() {
        /* View that handles showing list of characters, loader, etc. */
        RMService.shared.execute(
            .listCharactersRequests,
            expecting: RMGetAllCharactersResponse.self) /* 140 change String.self */
        { [weak self] result in  /* 127 */ /* 304 add weak self */
            
            switch result { /* 128 */
            case .success(let responseModel): /* 129 */
                let results = responseModel.results /* 302 */
                let info = responseModel.info /* 373 */
                self?.characters = results /* 305 */
                self?.apiInfo = info /* 375 */
                DispatchQueue.main.async { /* 318 */
                    self?.delegate?.didLoadInitialCharacters() /* 319 */
                }
                //print(String(describing: model)) /* 130 */
                //print("Example image url: "+String(model.results.first?.image ?? "No image")) /* 141 */
                //print("Page result count: "+String(model.results.count)) /* 142 */
            case .failure(let error): /* 131 */
                print(String(describing: error)) /* 132 */
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(url: URL) {/* 369 */
        guard !isLoadingMoreCharacters else { /* 444*/
            return
        }
//        print("Fettching more data") /* 468 */
        
        isLoadingMoreCharacters = true /* 416 */
//        print("Fetching more characters")
        guard let request = RMRequest(url: url) else { /* 435 */
            isLoadingMoreCharacters = false /* 436 */
//            print("Failed to create request") /* 437 */
            return /* 438 */
        }
        
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in /* 418 to turn a URL into a RM request */ /* 445 add [weak self] */
            guard let strongSelf = self else { /* 456 */
                return /* 457 */
            }
            switch result { /* 439 */
            case .success(let responseModel):
                let moreResults = responseModel.results /* 445 copy from fetchCharacters and paste */
//                print("Pre-update: \(strongSelf.cellViewModels.count)") /* 469 */
                let info = responseModel.info /* 445 */
                strongSelf.apiInfo = info /* 445 */
                
//                print(moreResults.count) /* 465 */
//                print(moreResults.first?.name) /* 466 */
                let originalCount = strongSelf.characters.count /* 455 */
                let newCount = moreResults.count /* 458 */
                let total = originalCount + newCount /* 459 */
                let startingIndex = total - newCount /* 460 */
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({ /* 461 compactMap - means to iterate over */
                    return IndexPath(row: $0, section: 0) /* 462 */
                })
//                print(indexPathsToAdd.count) /* 467 */
//                print(indexPathsToAdd) /* 463 */
                strongSelf.characters.append(contentsOf: moreResults) /* 445 */
//                print("Post-update: \(strongSelf.cellViewModels.count)") /* 470 */
//                print(String(strongSelf.characters.count)) /* 481 */
              //  print(String("ViewModels: "+strongSelf.cellViewModels.count)) /* 492 */
                DispatchQueue.main.async { /* 445 */
                    strongSelf.delegate?.didLoadMoreCharacters(
                        with: indexPathsToAdd /* 454  remove self?.characters.count ?? 0 and add [] */ /* 464 replace [] with indexPathsToAdd */
                    ) /* 445  to tell the collcetionView that it needs to update in fact that theere are now new characters */
                    strongSelf.isLoadingMoreCharacters = false /* 446 */
                }
//                print(String(describing: success)) /* 440 */
            case .failure(let failure):
                print(String(describing: failure)) /* 440 */
                self?.isLoadingMoreCharacters = false /* 447 */
            }
        }
        //Fetch characters
    }
    
    public var shouldShowLoadMoreIndicatior: Bool { /* 367 */
        return apiInfo?.next != nil /* 368 */ /* 376 add apiInfo.next == nil */
    }
}

            /*
             switch result {
             case .success(let model):
             print("Example image url: "+String(model.results.first?.image ?? "No Image"))
             case .failure(let error):
             print(String(describing: error))
             }
        }
    }
}
*/

//MARK: - CollectionView

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout /* 203 add UICollectionViewDelegate and UICollectionViewDelegateFlowLayout to get access for func in 204 */ { /* 189 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 190 numberOfItems */
        //return 20
        return cellViewModels.count /* 191 */ /* 311 replace "20" with cellViewModels.count */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 192 cellForItem */
        
        guard let cell = collectionView.dequeueReusableCell( /* 271 add guard let */
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, /* 225 replace "cell" with RMCharacter...cellIdentifier */
            for: indexPath /* 193 */
        ) as? RMCharacterCollectionViewCell else { /* 270 */
            fatalError("Unsupported cell") /* 272 */
        }
       //let viewModel = cellViewModels[indexPath.row] /* 312 */
        
        /*
        let viewModel = RMCharacterCollectionViewCellViewModel(characterName: "Danka",
                                                               characterStatus: .alive,
                                                               characterImageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")) /* 273 */ /* 301 add url */ 
         */
        
        cell.configure(with: cellViewModels[indexPath.row]) /* 274 */ /* 313 replace viewModel with cellViewModels*/
        //cell.backgroundColor = .systemGreen /* 195 */
        //cell.configure(with: viewModel) /* 274 */
        return cell /* 194 */
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView { /* 386 viewForSupplementaryElementOfKind */
        //guard kind == UICollectionView.elementKindSectionFooter else { /* 387 */
            //return UICollectionReusableView() /* 388 */
           // fatalError("Unsopported") /* 394 */
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView( /* 389 */ /* 406 add guard */
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView /* 404 */
                 else {
            fatalError("Unsupported") /* 394 */
        }
        footer.startAnimating() /* 405 */
        return footer /* 390 */
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize { /* 391 */
        guard shouldShowLoadMoreIndicatior else { /* 395 */
            return .zero /* 396 */
        }
        return CGSize(width: collectionView.frame.width, height: 100) /* 392 */
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { /* 205 */
        
//        let isIphone = UIDevice.current.userInterfaceIdiom == .phone /* 2103 */
        
        let bounds = collectionView.bounds /* 206 to ammit using constants */ /* 2102 change UIScreen.main to collectionView */
//        let width = (bounds.width-30)/2 /* 207 */
        let width: CGFloat /* 2104 */
        if UIDevice.isiPhone { /* 2105 */ /* 2176 change isIphone */
            width = (bounds.width-30)/2 /* 2106 */
        } else { /* 2107 */
            //mac | ipad
            width = (bounds.width-50)/4 /* 2108 */
        }
        return CGSize(
            width: width,
            height: width * 1.5
        ) /* 208 */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 336 didselect */
        collectionView.deselectItem(at: indexPath, animated: true) /* 337 to deselect item */
        let character = characters[indexPath.row] /* 338 */
        delegate?.didSelectCharacter(character) /* 339 */
    }
}

//MARK: - ScrollView
extension RMCharacterListViewViewModel: UIScrollViewDelegate { /* 370 */
    func scrollViewDidScroll(_ scrollView: UIScrollView) { /* 371 scrollViewDidScroll */
        guard shouldShowLoadMoreIndicatior,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty, /* 441 */
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else { /* 372 */ /* 415 add !isLoadingMoreCharacters */ /* 419 add conditions */
            return /* 372 */
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in /* 442 */
            let offset = scrollView.contentOffset.y /* 406 */
            let totalContentHeight = scrollView.contentSize.height /* 407 */
            let totalScrollViewFixedHeight = scrollView.frame.size.height /* 408 */
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) { /* 412 */
                //print("Should start fetching more") /* 413 */
                self?.fetchAdditionalCharacters(url: url) /* 417 */ /* 443 add self?. */
            }
            t.invalidate() /* 443 */
        }
        /*
        print("Offset: \(offset)") /* 409 */
        print("totalContentHeight: \(totalContentHeight)") /* 410 */
        print("totalScrollViewFixedHeight: \(totalScrollViewFixedHeight)") /* 411 */
         */
    }
}
