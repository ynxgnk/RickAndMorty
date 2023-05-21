//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 25.03.2023.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject { /* 1035 */
    func didFetchEpisodeDetails() /* 1036 */
}

final class RMEpisodeDetailViewViewModel { /* 927 */ /* 1032 add final */
    private let endpointUrl: URL? /* 928 */
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {/* 1031 */ /* 1118 add episode and characters */
        didSet { /* 1034 */
            createCellViewModels() /* 1112 */
            delegate?.didFetchEpisodeDetails() /* 1038 this will notify our delegate which will be the view that "you can now start reading data off of viewModel" */
        }
    }
    
    enum Sectiontype { /* 1104 */
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel]) /* 1105 */
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel]) /* 1106 */
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate? /* 1037 */
    
    public private(set) var cellViewModels: [Sectiontype] = [] /* 1111 we dont want public to be able to delete the sections or modify, it lets this property be public, but not for writing to it, only to reading */
    
    //MARK: - Init
    
    init(endpointUrl: URL?) { /* 929 */
        self.endpointUrl = endpointUrl /* 930 */
//        fetchEpisodeData() /* 939 */ /* 1041 comment this line */
    }
    
    public func character(at index: Int) -> RMCharacter? { /* 1223 */
        guard let dataTuple = dataTuple else { /* 1224 */
            return nil /* 1225 */
        }
        return dataTuple.characters[index] /* 1226 */
    }
    
    
    //MARK: - Public
    
    //MARK: - Private
    
    private func createCellViewModels() { /* 1113 */
        guard let dataTuple = dataTuple else { /* 1118 */
            return /* 1119 */
        }
        
        let episode = dataTuple.episode /* 1114 */
        let characters = dataTuple.characters /* 1122 */
        
        var createdString = episode.created /* 1212 */
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) { /* 1213 */
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date) /* 1214 */
        }
        
        cellViewModels = [ /* 1115 */
            .information(viewModels: [ /* 1116 */
                .init(title: "Episode Name", value: episode.name), /* 1117 */
                .init(title: "Air Date", value: episode.air_date), /* 1117 */
                .init(title: "Episode ", value: episode.episode), /* 1117 */
                .init(title: "Created", value: createdString) /* 1117 */ /* 1211 change episode.created to createdString */
            ]),
            .characters(viewModel: characters.compactMap({ character in /* 1123  */
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name, /* 1124 replace $0 to character */
                    characterStatus: character.status, /* 1124 replace $0 to character */
                    characterImageUrl: URL(string: character.image) /* 1124 replace $0 to character */
                )
            }))
        ]
    }
    
    /// Fetch backing episode model
    public func fetchEpisodeData() { /* 938 */ /* 1040 change to public */
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else { /* 940 */ /* 949 add url to guard */
            return /* 941 */
        }
        
        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) { [weak self] result in /* 943 */ /* 1013 add weak self */
            switch result { /* 944 */
            case .success(let model): /* 945 */
//                print(String(describing: model)) /* 946 */
                self?.fetchRelatedCharacters(episode: model) /* 1012 */
            case .failure: /* 947 */
                break /* 948 */
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: RMEpisode) { /* 1011 */
        let requests: [RMRequest] = episode.characters.compactMap({ /* 1014 */
            return URL(string: $0) /* 1015 */
        }).compactMap({ /* 1016 it will firstly create a collecton of URLs from the strings and then its gonna loop over those and attempt to create a collection of requests from those urls  */
            return RMRequest(url: $0) /* 1017 */
        })
        
        //a Dispatch group lets you kick off any number of parallel requests and then we get notified once all done
        
        let group = DispatchGroup() /* 1018 */
        var characters: [RMCharacter] = [] /* 1026 */
        for request in requests { /* 1019 */
            group.enter() /* 1020 means: something has started */ // +1
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in /* 1021 */
                defer { /* 1028 defer means: this is the last thing thats going to run before the execution of our program exits the scope of this closure(switch will run firstly, and the last stand is going to run its going to tell our group "whatever thing we kicked off and started, we left that */
                    group.leave() /* 1029 */ //decrement -1
                }
                
                switch result { /* 1022 */
                case .success(let model): /* 1023 */
                    characters.append(model) /* 1027 */
                case .failure: /* 1024 */
                    break /* 1025 */
                }
            }
        }
        
        group.notify(queue: .main) { /* 1030 */
            self.dataTuple = ( /* 1033 */
                episode: episode, /* 1120 add episode: */
                characters: characters /* 1121 add characters: */
            )
        }
    }
}
