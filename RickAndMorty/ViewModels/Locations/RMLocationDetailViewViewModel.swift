//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 01.04.2023.
//

import Foundation

protocol RMLocationDetailViewViewModelDelegate: AnyObject { /* 1523 copy all file from RMEpisodeDetailViewViewModel and change */
    func didFetchLocationDetails() /* 1523 */
}

final class RMLocationDetailViewViewModel { /* 1523 */
    private let endpointUrl: URL? /* 1523 */
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {/* 1523 */
        didSet { /* 1523 */
            createCellViewModels() /* 1523 */
            delegate?.didFetchLocationDetails() /* 1523 */
        }
    }
    
    enum Sectiontype { /* 1523 */
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel]) /* 1523 */
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel]) /* 1523 */
    }
    
    public weak var delegate: RMLocationDetailViewViewModelDelegate? /* 1523 */
    
    public private(set) var cellViewModels: [Sectiontype] = [] /* 1523 */
    
    //MARK: - Init
    
    init(endpointUrl: URL?) { /* 1523 */
        self.endpointUrl = endpointUrl /* 1523 */
    }
    
    public func character(at index: Int) -> RMCharacter? { /* 1523 */
        guard let dataTuple = dataTuple else { /* 1523 */
            return nil /* 1523 */
        }
        return dataTuple.characters[index] /* 1523 */
    }
    
    
    //MARK: - Public
    
    //MARK: - Private
    
    private func createCellViewModels() { /* 1523 */
        guard let dataTuple = dataTuple else { /* 1523 */
            return /* 1523 */
        }
        
        let location = dataTuple.location /* 1523 */
        let characters = dataTuple.characters /* 1523 */
        
        var createdString = location.created /* 1523 */
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) { /* 1523 */
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date) /* 1523 */
        }
        
        cellViewModels = [ /* 1523 */
            .information(viewModels: [ /* 1523 */
                .init(title: "Location Name", value: location.name), /* 1523 */
                .init(title: "Type", value: location.type), /* 1523 */
                .init(title: "Dimension ", value: location.dimension), /* 1523 */
                .init(title: "Created", value: createdString) /* 1523 */
            ]),
            .characters(viewModel: characters.compactMap({ character in /* 1523  */
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name, /* 1523 */
                    characterStatus: character.status, /* 1523 */
                    characterImageUrl: URL(string: character.image) /* 1523 */
                )
            }))
        ]
    }
    
    /// Fetch backing location model
    public func fetchLocationData() { /* 1523 */
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else { /* 1523 */
            return /* 1523 */
        }
        
        RMService.shared.execute(request,
                                 expecting: RMLocation.self) { [weak self] result in /* 1523 */
            switch result { /* 1523 */
            case .success(let model): /* 1523 */
                self?.fetchRelatedCharacters(location: model) /* 1523 */
            case .failure: /* 1523 */
                break /* 1523 */
            }
        }
    }
    
    private func fetchRelatedCharacters(location: RMLocation) { /* 1523 */
        let requests: [RMRequest] = location.residents.compactMap({ /* 1523 */
            return URL(string: $0) /* 1523 */
        }).compactMap({ /* 1523 */
            return RMRequest(url: $0) /* 1523 */
        })
        
        let group = DispatchGroup() /* 1523 */
        var characters: [RMCharacter] = [] /* 1523 */
        for request in requests { /* 1523 */
            group.enter() /* 1523 */ // +1
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in /* 1523 */
                defer { /* 1523 */
                    group.leave() /* 1523 */ //decrement -1
                }
                
                switch result { /* 1523 */
                case .success(let model): /* 1523 */
                    characters.append(model) /* 1523 */
                case .failure: /* 1523 */
                    break /* 1523 */
                }
            }
        }
        
        group.notify(queue: .main) { /* 1523 */
            self.dataTuple = ( /* 1523 */
                location: location, /* 1523 */
                characters: characters /* 1523 */
            )
        }
    }
}
