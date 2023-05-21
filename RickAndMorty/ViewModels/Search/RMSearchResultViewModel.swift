//
//  RMSearchResultType.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 05.04.2023.
//

import Foundation

//protocol RMSearchResultRepresentable { /* 1888 */
//    associatedtype ResultType /* 1889 */
//
//    var results: [ResultType] { get } /* 1890 */
//}

final class RMSearchResultViewModel { /* 2113 */
    public private(set) var results: RMSearchResultType /* 2114 */
    private var next: String? /* 2124 copy from RMGetAllCharactersResponse */
    
    init(results: RMSearchResultType, next: String?) { /* 2113 */
        self.results = results /* 2113 */
        self.next = next /* 2113 */
//        print(next) /* 2147 */
    }
    
    public private(set) var isLoadingMoreResults = false /* 2134 */
    
    public var shouldShowLoadMoreIndicatior: Bool { /* 2132 */
        return next != nil /* 2133 */
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) { /* 2135 */ /* 2142 add completion */ /* 2149 add [RMLocationTVCVM] */
        guard !isLoadingMoreResults else { /* 2136 copy from 2063 and paste */
            return /* 2136 */
        }
        
        guard let nextUrlString = next, /* 2136 */
              let url = URL(string: nextUrlString) else { /* 2136 */
            return /* 2136 */
        }
        
        isLoadingMoreResults = true /* 2136 */
        
        guard let request = RMRequest(url: url) else { /* 2136 */
            isLoadingMoreResults = false /* 2136 */
            return /* 2136 */
        }
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in /* 2136 */
            guard let strongSelf = self else { /* 2136 */
                return /* 2136 */
            }
            switch result { /* 2136 */
            case .success(let responseModel): /* 2136 */
                let moreResults = responseModel.results /* 2136 */
                let info = responseModel.info /* 2136 */
                strongSelf.next = info.next /* 2136 Capture new pagination url */
                
                let additionalLocations = moreResults.compactMap({ /* 2137 */
                    return RMLocationTableViewCellViewModel(location: $0) /* 2136 */
                })
                var newResults: [RMLocationTableViewCellViewModel] = [] /* 2151 */
                
                switch strongSelf.results { /* 2138 */
                case .locations(let existingResults): /* 2139 */
                    newResults = existingResults + additionalLocations /* 2140 */
                    strongSelf.results = .locations(newResults) /* 2141 */
                    break
                case .characters, .episodes: /* 2139 */
                    break
                }
                
                DispatchQueue.main.async { /* 2136 */
                    strongSelf.isLoadingMoreResults = false /* 2136 */
                    
                    //Notify via callback
                    completion(newResults) /* 2143 */ /* 2150 add newResults */
                }
            case .failure(let failure): /* 2136 */
                print(String(describing: failure)) /* 2136 */
                self?.isLoadingMoreResults = false /* 2136 */
            }
        }
    }
    
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) { /* 2165 copy from 2135 */
        guard !isLoadingMoreResults else { /* 2165 */
            return /* 2165 */
        }
        
        guard let nextUrlString = next, /* 2165 */
              let url = URL(string: nextUrlString) else { /* 2165 */
            return /* 2165 */
        }
        
        isLoadingMoreResults = true /* 2165 */
        
        guard let request = RMRequest(url: url) else { /* 2165 */
            isLoadingMoreResults = false /* 2165 */
            return /* 2165 */
        }
        
        switch results { /* 2166 */
        case .characters(let existingResults): /* 2167 */
            RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in /* 2165 */
                guard let strongSelf = self else { /* 2165 */
                    return /* 2165 */
                }
                switch result { /* 2165 */
                case .success(let responseModel): /* 2165 */
                    let moreResults = responseModel.results /* 2165 */
                    let info = responseModel.info /* 2165 */
                    strongSelf.next = info.next /* 2165 */
                    
                    let additionalResults = moreResults.compactMap({ /* 2165 */
                        return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                                      characterStatus: $0.status,
                                                                      characterImageUrl: URL(string: $0.image)) /* 2165 */
                    })
                    var newResults: [RMCharacterCollectionViewCellViewModel] = [] /* 2165 */
                    newResults = existingResults + additionalResults /* 2165 */
                    strongSelf.results = .characters(newResults) /* 2165 */
                    
                    DispatchQueue.main.async { /* 2165 */
                        strongSelf.isLoadingMoreResults = false /* 2165 */
                        
                        //Notify via callback
                        completion(newResults) /* 2165 */
                    }
                case .failure(let failure): /* 2165 */
                    print(String(describing: failure)) /* 2165 */
                    self?.isLoadingMoreResults = false /* 2165 */
                }
            }
        case .episodes(let existingResults): /* 2167 */
            RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in /* 2168 copy from 2165 */
                guard let strongSelf = self else { /* 2168 */
                    return /* 2168 */
                }
                switch result { /* 2168 */
                case .success(let responseModel): /* 2168 */
                    let moreResults = responseModel.results /* 2168 */
                    let info = responseModel.info /* 2168 */
                    strongSelf.next = info.next /* 2168 */
                    
                    let additionalResults = moreResults.compactMap({ /* 2168 */
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url)) /* 2168 */
                    })
                    var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = [] /* 2168 */
                    newResults = existingResults + additionalResults /* 2168 */
                    strongSelf.results = .episodes(newResults) /* 2168 */
                    
                    DispatchQueue.main.async { /* 2168 */
                        strongSelf.isLoadingMoreResults = false /* 2168 */
                        
                        //Notify via callback
                        completion(newResults) /* 2168 */
                    }
                case .failure(let failure): /* 2168 */
                    print(String(describing: failure)) /* 2168 */
                    self?.isLoadingMoreResults = false /* 2168 */
                }
            }
        case .locations: /* 2167 */
            //TableView case
            break
        }
    }
}

enum RMSearchResultType { /* 1868 */ /* 2112 change name from RMSearchResultViewModel */
    case characters([RMCharacterCollectionViewCellViewModel]) /* 1891 */ /* 1907 add a viewModel */
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel]) /* 1891 */ /* 1908 add a viewModel */
    case locations([RMLocationTableViewCellViewModel]) /* 1891 */ /* 1909 add a viewModel */
}
