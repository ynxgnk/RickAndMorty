//
//  RMService.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 14.03.2023.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService { /* 36 */
    /// Shared singleton instance
    static let shared = RMService() /* 37 */
    
    private let cacheManager = RMAPICacheManager() /* 902 */
    
    /// Privatized constructor
    private init() {} /* 38 */
    
    enum RMServiceError: Error { /* 106 */
        case failedToCreateRequest /* 107 */
        case failedToGetData /* 110 */
    }

    /// Send rick and Morty API Call
    /// - Parameters:
    ///   - request: request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: callback with data or error
    public func execute<T: Codable>( /* 92 add T: Codable*/
    _ request: RMRequest,
     expecting type: T.Type, /* 93 */
     completion: @escaping (Result<T, Error>) -> Void) { /* 39 */ /* 59 */ /* 94 change String to T */
         
         if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) { /* 919 */
//             print("Using cached API Response") /* 926 means: whatever EpisodesViewModels get triggered, the cell comes into view, actually goes and says: fetch the content for episodes */
             do { /* 922 add do-catch */
                 let result = try JSONDecoder().decode(type.self, from: cachedData) /* 921 copy from do-catch loop and paste */
                 completion(.success(result)) /* 921 */
             }
             catch { /* 922 */
                 completion(.failure(error)) /* 923 */
             }
             return /* 920 */
         }
         
        guard let urlRequest = self.request(from: request) else { /* 103 */
            completion(.failure(RMServiceError.failedToCreateRequest)) /* 104 */
            return /* 105 */
        }
//         print("API Call: \(request.url?.absoluteString ?? "")") /* 472 */
         
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in /* 108 */ /* 924 add [weak self] */
            guard let data = data, error == nil else { /* 109 */
                completion(.failure(error ?? RMServiceError.failedToGetData)) /* 111 */
                return /* 112 */
            }
            
            //Decode the response to raw JSON
            do { /* 113 */
                let result = try JSONDecoder().decode(type.self, from: data) /* 123 */
                self?.cacheManager.setCache(
                    for: request.endpoint,
                    url: request.url,
                    data: data
                ) /* 925 */
                completion(.success(result)) /* 124 its up to the caller to pass back a appropriate model to which the response of API request can be decoded */
                            
                 //let json = try JSONSerialization.jsonObject(with: data) /* 114 */
                 //print(String(describing: json)) /* 115 */
            }
            catch {
                completion(.failure(error)) /* 116 */
            }
        }
        task.resume() /* 117 it kicks off task for URLSession */
    }
    
    private func request(from rmRequest: RMRequest) -> URLRequest? { /* 98 */
        guard let url = rmRequest.url else { return nil } /* 99 */
        
        var request = URLRequest(url: url) /* 100 */
        request.httpMethod = rmRequest.httpMethod /* 102 */
        return request /* 101 */
    }
}

