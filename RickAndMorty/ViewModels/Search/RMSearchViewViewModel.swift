//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 02.04.2023.
//

import Foundation

//Responsibilities
// - show search results
// - show no results view
// - kick off API requests

final class RMSearchViewViewModel { /* 1543 */
    let config: RMSearchViewController.Config /* 1544 */
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:] /* 1777 */
    private var searchText = "" /* 1803 */
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)? /* 1784 */
    
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)? /* 1848 */ /* 1901 add RMSearchResultType */ /* 2115 change RMSearchResultType */
    
    private var noResultsHandler: (() -> Void)? /* 1942 */
    
    private var searchResultModel: Codable? /* 2001 */
    
    //MARK: - Init
    
    init(config: RMSearchViewController.Config) { /* 1545 */
        self.config = config /* 1546 */
    }
    
    //MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) { /* 1847 */ /* 1904 add RMSearchResultType */ /* 2116 change RMSearchResultType to RMRMSearchResultViewModel */
        self.searchResultHandler = block /* 1849 */
    }
    
    public func registerNoResultsHandler(_ block: @escaping () -> Void) { /* 1943 */
        self.noResultsHandler = block /* 1944 */
    }
    
    public func executeSearch() { /* 1802 */
        //Create Request based on filters
        //https://rickandmortyapi.com/api/character/?name=rick&status=alive
        //Test search text
//        searchText = "Rick" /* 1846 */
//        print("Search text: \(searchText)") /* 1865 */
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { /* 2109 */
            return /* 2110 */
        }
        
        //Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) /* 1845 */ /* 1866 add adding... to be able to search with "space" */
        ] /* 1837 */
        
//        switch config.type { /* 1806 */
//        case .character, .episode: /* 1807 */ /* 1843 add .episode */
//            searchText = "Rick" /* 1826 */
//              var queryParams = [URLQueryItem(name: "name", value: searchText)] /* 1834 */
//              queryParams.append(URLQueryItem(name: "name", value: searchText)) /* 1838 */
//            var urlString = "https://rickandmortyapi.com/api/character/" /* 1808 */ /* 1833 comment */
//            urlString += "?name=\(searchText)" /* 1809 */
//            for (option, value) in optionMap { /* 1815 */ /* 1833 comment loop */
//                urlString += "&\(option.queryArgument)=\(value)" /* 1816 */
//            }
//            print(urlString) /* 1827 */ /* 1833 comment */
//            guard let url = URL(string: urlString) else { /* 1817 */ /* 1833 comment */
//                return /* 1818 */
//            }
//            guard let request = RMRequest(url: url) else { /* 1819 */ /* 1833 comment */
//                return /* 1820 */
//            }
//        case .location: /* 1807 */
//            queryParams.append(URLQueryItem(name: "name", value: searchText)) /* 1844 change break */
//        }
        
        //Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in /* 1829 */ /* 1835 queryParams.append + copy from request */
            let key: RMSearchInputViewViewModel.DynamicOption = element.key /* 1830 */
            let value: String = element.value /* 1831 */
            return URLQueryItem(name: key.queryArgument, value: value) /* 1832 */
        }))
        
        //Send API call
        //Create request
        let request = RMRequest(
            endpoint: config.type.endpoint, /* 1839 change .character */
            queryParameters: queryParams /* 1836 replace queryParameters to queryParams and call this here */
        ) /* 1828 */
        
//        print(request.url?.absoluteString) /* 1850 */
        
        //Execute Request
        
            /*
             switch config.type.endpoint { /* 1870 */
             case .character:
                 RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { result in /* 1871 copy from .location and paste */
                     switch result { /* 1871 */
                     case .success(let model): /* 1871 */
                         print("Search results found: \(model.results.count)") /* 1871 */
                     case .failure: /* 1871 */
                         print("Failed to get results") /* 1871 */
                         break /* 1871 */
                     }
                 }
             case .episode:
                 RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { result in /* 1872 copy and paste from .location */
                     switch result { /* 1872 */
                     case .success(let model): /* 1872 */
                         print("Search results found: \(model.results.count)") /* 1872 */
                     case .failure: /* 1872 */
                         print("Failed to get results") /* 1872 */
                         break /* 1872 */
                     }
                 }
             case .location:
             }
             */
        
        switch config.type.endpoint { /* 1875 */
        case .character: /* 1876 */
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request) /* 1877 */
        case .episode: /* 1876 */
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request) /* 1877 */
        case .location: /* 1876 */
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request) /* 1877 */
        }
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) { /* 1873 */
        RMService.shared.execute(request, expecting: type) { [weak self] result in /* 1821 */ /* 1879 add weak self */
            //Notify view of results, no results, or error
            
            switch result { /* 1822 */
            case .success(let model): /* 1823 */
                self?.processSearchResults(model: model) /* 1880 */
            case .failure: /* 1823 */
                print("Failed to get results") /* 1869 */
                self?.handleNoResults() /* 1940 */
                break /* 1825 */
            }
        }
    }
    
    private func processSearchResults(model: Codable) { /* 1878 */
        var resultsVM: RMSearchResultType? /* 1897 */
        var nextUrl: String? /* 2125 */
        if let characterResults = model as? RMGetAllCharactersResponse {
//            print("Results: \(characterResults.results)") /* 1885 */
            resultsVM = .characters(characterResults.results.compactMap({ /* 1910 add characterResults.results.compactMap */
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                ) /* 1911 */
            })) /* 1894 */
            nextUrl = characterResults.info.next /* 2126 */
//             self.searchResultHandler?(resultsVM) /* 1898 */
        } /* 1881 */
        else if let episodesResults = model as? RMGetAllEpisodesResponse {
//            print("Results: \(episodesResults.results)") /* 1886 */
            resultsVM = .episodes(episodesResults.results.compactMap({ /* 1912 add characterResults.results.compactMap */
                return RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url)
                ) /* 1913 */
            })) /* 1895 */
            nextUrl = episodesResults.info.next /* 2127 */
//             self.searchResultHandler?(resultsVM) /* 1899 */
        } /* 1882 */
        else if let locationsResults = model as? RMGetAllLocationsResponse {
//            print("Results: \(locationsResults.results)") /* 1887 */
            resultsVM = .locations(locationsResults.results.compactMap({ /* 1914 add characterResults.results.compactMap */
                return RMLocationTableViewCellViewModel(location: $0) /* 1915 */
            })) /* 1896 */
            nextUrl = locationsResults.info.next /* 2128 */
//             self.searchResultHandler?(resultsVM) /* 1900 */
        } /* 1883 */
        if let results = resultsVM { /* 1884 */
            self.searchResultModel = model /* 2000 */
            let vm = RMSearchResultViewModel(results: results, next: nextUrl) /* 2117 */ /* 2129 add next */
            self.searchResultHandler?(vm) /* 1903 */ /* 2118 change results to vm */
        } else { /* 1902 */
            //fallback error
            handleNoResults() /* 1939 */
        }
    }
    
    public func handleNoResults() { /* 1938 */
        print("No Results") /* 1941 */
        noResultsHandler?() /* 1945 */
    }
    
    public func set(query text: String) { /* 1804 */
        self.searchText = text /* 1805 */
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) { /* 1776 */
        optionMap[option] = value /* 1778 */
        let tuple = (option, value) /* 1786 */
        optionMapUpdateBlock?(tuple) /* 1787 */
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) { /* 1783 */
        self.optionMapUpdateBlock = block /* 1785 */
    }
    
    public func locationSearchResult(at index: Int) -> RMLocation? { /* 2003 */
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else { /* 2004 */
            return nil /* 2005 */
        }
        return searchModel.results[index] /* 2006 */
    }
    
    public func characterSearchResult(at index: Int) -> RMCharacter? { /* 2198 copy from 2003 and paste */
        guard let searchModel = searchResultModel as? RMGetAllCharactersResponse else { /* 2198 */
            return nil /* 2198 */
        }
        return searchModel.results[index] /* 2198 */
    }
    
    public func episodeSearchResult(at index: Int) -> RMEpisode? { /* 2204 copy from 2003 and paste */
        guard let searchModel = searchResultModel as? RMGetAllEpisodesResponse else { /* 2204 */
            return nil /* 2204 */
        }
        return searchModel.results[index] /* 2204 */
    }
}
