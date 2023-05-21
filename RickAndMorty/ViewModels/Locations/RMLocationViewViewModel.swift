//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 31.03.2023.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject { /* 1403 */
    func didFetchInitialLocations() /* 1404 */
}

final class RMLocationViewViewModel { /* 1363 */
    
    weak var delegate: RMLocationViewViewModelDelegate? /* 1405 */
    
    private var locations: [RMLocation] = [] { /* 1375 */
        didSet { /* 1429 */
            for location in locations { /* 1430 */
                let cellViewModel = RMLocationTableViewCellViewModel(location: location) /* 1431 */ /* 1450 add location as a parameter */

                if !cellViewModels.contains(cellViewModel) { /* 1451 */
                    cellViewModels.append(cellViewModel) /* 1432 */
                }
            }
        }
    }
    
    //Location response info
    //will contain newxt url, if present
    private var apiInfo: RMGetAllLocationsResponse.Info? /* 1410 */
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = [] /* 1376 */ /* 1428 change String to RMLocationTableViewCellViewModel */ /* 1439 change to public private(set) */
    
    public var shouldShowLoadMoreIndicatior: Bool { /* 2062 copy from 957 */
        return apiInfo?.next != nil /* 2062 */
    }
    
    public var isLoadingMoreLocations = false /* 2061 */
    
    private var didFinishPagination: (() -> Void)? /* 2096 */
    
    //MARK: - Init
    
    init() {} /* 1364 */
    
    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) { /* 2097 */
        self.didFinishPagination = block /* 2098 */
    }
    
    /// Paginate if additional locations are needed
    public func fetchAdditionalLocations() { /* 2063 copy from 957 and paste */
        guard !isLoadingMoreLocations else { /* 2063 */
            return
        }
        
        guard let nextUrlString = apiInfo?.next, /* 2064 means: get the next object of apiInfo and try to create a URL with whatever is next */
              let url = URL(string: nextUrlString) else { /* 2064 */
            return /* 2064 */
        }
        
        isLoadingMoreLocations = true /* 2063 */
        
        guard let request = RMRequest(url: url) else { /* 2063 */
            isLoadingMoreLocations = false /* 2063 */
            return /* 2063 */
        }
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in /* 2063 */
            guard let strongSelf = self else { /* 2063 */
                return /* 2063 */
            }
            switch result { /* 957 */
            case .success(let responseModel):
                let moreResults = responseModel.results /* 2063 */
                let info = responseModel.info /* 2063 */
//                print("More locations: \(moreResults.count)") /* 2065 */
                strongSelf.apiInfo = info /* 2063 */
//                print(info.next) /* 2101 */ 
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0) /* 2091 */
                })) /* 2090 */
                DispatchQueue.main.async { /* 2063 */
                    strongSelf.isLoadingMoreLocations = false /* 2063 */
                    
                    //Notify via callback
                    strongSelf.didFinishPagination?() /* 2095 */
                }
            case .failure(let failure): /* 2063 */
                print(String(describing: failure)) /* 2063 */
                self?.isLoadingMoreLocations = false /* 2063 */
            }
        }
        //Fetch characters
    }
    
    public func location(at index: Int) -> RMLocation? { /* 1502 */
        guard index < locations.count, index >= 0 else { /* 1503 */
            return nil /* 1504 */
        }
        return self.locations[index] /* 1505 */
    }
 
    public func fetchLocations() { /* 1374 */
        RMService.shared.execute(
            .listLocationsRequest,
            expecting: RMGetAllLocationsResponse.self
        ) { [weak self] result in /* 1380 */ /* 1406 add weak self */ /* 1409 change Sting.self to RMGetAllLocationsResponse.self */
            switch result { /* 1381 */
            case .success(let model): /* 1382 */
                //break /* 1383 */
                self?.apiInfo = model.info /* 1411 */
                self?.locations = model.results /* 1412 */ 
                DispatchQueue.main.async { /* 1413 */
                    self?.delegate?.didFetchInitialLocations() /* 1407 */
                }
            case .failure(let error): /* 1382 */
                break /* 1384 */
            }
        }
    }
    
    private var hasMoreResults: Bool { /* 1377 */
        return false /* 1378 */
    }
}
