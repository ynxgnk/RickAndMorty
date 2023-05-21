//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 14.03.2023.
//

import Foundation

/// Object that represents single API call
final class RMRequest { /* 40 */
    //Base url
    //Endpoint
    //Path component
    //query parameters
    
    private struct Constants { /* 60 */
        
        /// API Constance
        static let baseURL = "https://rickandmortyapi.com/api" /* 61 */
    }
    
    
    /// Desired endpoint
    let endpoint: RMEndpoint /* 62 */ /* 918 remove private */
    
    ///  Path components for API,if any
    private let pathComponents: [String] /* 63 */
    
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem] /* 64 */
    
    /// Constructured url for the api request in string format
    private var urlString: String { /* 71 */
        var string = Constants.baseURL /* 72 */
        string += "/" /* 73 */
        string += endpoint.rawValue /* 74 */
        
        if !pathComponents.isEmpty { /* 76 */
            pathComponents.forEach({ /* 77 */
                string += "/\($0)" /* 78 $0 - represents the perticular path component */
            })
        }
        
        if !queryParameters.isEmpty { /* 79 */
            string += "?" /* 80 */
            //name = value & name = value
                let argumentString = queryParameters.compactMap({ /* 81  compactMap - is going to change queryParameters */
                    guard let value = $0.value else { return nil } /* 82 */
                    return "\($0.name)=\(value)" /* 83 $0 - represents the current element in the iteration */
                }).joined(separator: "&") /* 84 */
            
            string += argumentString /* 85 */
        }
        
        return string /* 75 */
    }
    
    /// Computed & constructed API url
    public var url: URL? { /* 69 */
        return URL(string: urlString) /* 70 */
    }
    
    /// Desired http method
    public let httpMethod = "GET" /* 96 */
    
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collecting of Path components
    ///   - queryParameters: Collection of query parameters
    public init(
        endpoint: RMEndpoint, /* 65 */
        pathComponents: [String] = [], /* 65 */
        queryParameters: [URLQueryItem] = [] /* 65 */
    ) { /* 65 */
        self.endpoint = endpoint /* 66 */
        self.pathComponents = pathComponents /* 67 */
        self.queryParameters = queryParameters /* 68 */
    }
    
    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) { /* 420 want to parse URL and attempt to get back initialized RM request */
        let string = url.absoluteString /* 421 */
        if !string.contains(Constants.baseURL) { /* 422 */
            return nil /* 423 */
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL+"/", with: "") /* 424 want to trim the string */
        if trimmed.contains("/") { /* 425 parsing the trimmed URL */
            let components = trimmed.components(separatedBy: "/") /* 427 */
            if !components.isEmpty { /* 428 */
                let endpointString = components[0] /* 429 */ //Endpoint
                var pathComponents: [String] = [] /* 532 */
                if components.count > 1 { /* 533 */
                    pathComponents = components /* 534 */
                    pathComponents.removeFirst() /* 535 */
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) { /* 431 */
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents) /* 432 */ /* 531 add pathComponents */
                    return /* 433 */
                }
            }
        } else if trimmed.contains("?") {  /* 426 */
            let components = trimmed.components(separatedBy: "?") /* 434 copy from "/" and paste  */
            if !components.isEmpty, components.count >= 2 { /* 434 */ /* 474 add condition components.count */
                let endpointString = components[0] /* 434 */
                let queryItemsString = components[1] /* 473 */
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else { /* 476 */
                        return nil /* 477 */
                    }
                    let parts = $0.components(separatedBy: "=") /* 478 */
                    
                    return URLQueryItem( /* 479 */
                        name: parts[0],
                        value: parts[1]
                    )
                }) /* 475 */
                
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) { /* 434 */
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems) /* 434 */ /* 480 add queryParameters */
                    return /* 434 */
                }
            }
        }
                return nil /* 430 */
            }
            
        }
        
            extension RMRequest { /* 125 */
                static let listCharactersRequests = RMRequest(endpoint: .character) /* 126 */
                static let listEpisodesRequest = RMRequest(endpoint: .episode) /* 964 */
                static let listLocationsRequest = RMRequest(endpoint: .location) /* 1379 */
            }
