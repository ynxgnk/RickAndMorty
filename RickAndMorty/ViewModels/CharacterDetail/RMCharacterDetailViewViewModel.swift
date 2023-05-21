//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 19.03.2023.
//

import UIKit /* 610 add UIKit */

final class RMCharacterDetailViewViewModel { /* 353 */
    
    private let character: RMCharacter /* 356 */
    
    public var episodes: [String] { /* 886 */
        character.episode /* 887 */
    }
    
    enum SectionType { /* 577 add CaseIterable protocol*/ /* 622 remove CaseIterable protocol */
        case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel) /* 578 */ /* 619 add viewModel*/
        
        case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel]) /* 578 */ /* 620 add viewModels */
        
        case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellViewModel]) /* 578 */ /* 621 add viewModels */
    }
    
//    public let sections = SectionType.allCases /* 579 */
    public var sections: [SectionType] = [] /* 623 */
    //MARK: - Init
    
    init(character: RMCharacter) { /* 354 */
        self.character = character /* 357 */
        setUpSections() /* 624 */
    }
    
    private func setUpSections() { /* 625 */
        sections = [ /* 626 */
            .photo(viewModel: .init(imageUrl: URL(string: character.image))), /* 627 */ /* 677 add imageUrl */
                .information(viewModels: [ /* 628 */
                    .init(type: .status ,value: character.status.rawValue), /* 629 */ /* 678 add parameters */ /* 752 delete titles */
                        .init(type: .gender ,value: character.gender.rawValue), /* 629 */ /* 678 add parameters */ /* 752 */
                        .init(type: .type ,value: character.type), /* 629 */ /* 678 add parameters */ /* 752 */
                        .init(type: .species ,value: character.species), /* 629 */ /* 678 add parameters */ /* 752 */
                        .init(type: .origin ,value: character.origin.name), /* 629 */ /* 678 add parameters */ /* 752 */
                        .init(type: .location ,value: character.location.name), /* 629 */ /* 678 add parameters */ /* 752 */
                        .init(type: .created ,value: character.created), /* 629 */ /* 678 add parameters */ /* 752 */
                        .init(type: .episodeCount ,value: "\(character.episode.count)"), /* 629 */ /* 678 add parameters */ /*752 */
                ]),
            .episodes(viewModels: character.episode.compactMap ({  /* 630 */ /* 679 change parameters */
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0)) /* 680 */
//                    .init(), /* 631 */
//                    .init(), /* 631 */
//                    .init(), /* 631 */
//                    .init() /* 631 */
            }))
        ]
    }
    
    private var requestUrl: URL? { /* 521 */
        return URL(string: character.url) /* 522 */
    }
    
    public var title: String { /* 358 */
        character.name.uppercased() /* 359 */
    }
    //MARK: - Layouts
    
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection{ /* 587 create func */ /* 611 change to public */
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize( /* 561 */
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: 0,
                                                     bottom: 10,
                                                     trailing: 0) /* 576 to create an Inset */
        
        let group = NSCollectionLayoutGroup.vertical( /* 559 */
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)
            ),
            subitems: [item] /* 562 */
        )
        let section = NSCollectionLayoutSection(group: group) /* 560 */
        return section /* 563 */
    }
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection { /* 588 create func */ /* 611 change to public */
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize( /* 589 copy from createPhotoSectionLayout func and paste */
            widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.5 : 0.25), /* 2180 add UIDevice.isiPhone */
            heightDimension: .fractionalHeight(1.0)
           )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        ) /* 589 */
        
        let group = NSCollectionLayoutGroup.horizontal( /* 589 */ /* 606 change vertical to horizontal */
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: UIDevice.isiPhone ? [item, item] : [item, item, item, item] /* 589 */ /* 607 add one more item */ /* 2181 add UIDevice and 4 items */
        )
        let section = NSCollectionLayoutSection(group: group) /* 589 */
        return section /* 589 */
    }
    
    public func createEpisodeSectionLayout() -> NSCollectionLayoutSection{ /* 590 create func */ /* 612 change to public */
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize( /* 591 copy and paste */
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 8
        ) /* 591*/
        
        let group = NSCollectionLayoutGroup.horizontal( /* 591 */ /* 608 change to horiontal */
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.8 : 0.4), /* 2182 add UIDevice.isiPhone */
                heightDimension: .absolute(150)
            ),
            subitems: [item] /* 591 */
        )
        let section = NSCollectionLayoutSection(group: group) /* 591 */
        section.orthogonalScrollingBehavior = .groupPaging /* 609 */
        return section /* 591 */
    }
    /*
     public func fetchCharacterData() { /* 524 */
     //        print(character.url) /* 528 */
     guard let url = requestUrl, /* 525 */
     let request = RMRequest(url: url) else { /* 526 */
     print("Failed to create") /* 529 */
     return /* 527 */
     }
     RMService.shared.execute(request, expecting: RMCharacter.self) { result in /* 536 */
     switch result { /* 537 */
     case .success(let success): /* 538 */
     print(String(describing: success)) /* 539 */
     case .failure(let failure): /* 540 */
     print(String(describing: failure)) /* 541 */
     }
     }
     //        print(request.url) /* 530 */
     }
     */
}
