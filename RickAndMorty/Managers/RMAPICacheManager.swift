//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 25.03.2023.
//

import Foundation

/// Manages in memory session scoped API caches
final class RMAPICacheManager { /* 900 */
    //API URL: Data
    
    private var cacheDictionary: [
        RMEndpoint: NSCache<NSString, NSData>
    ] = /*RMEndpoint.allCases.compactMap({ */ [:] /* 904 */
    
//    private var cache = NSCache<NSString, NSData>() /* 903 */
    
    
    init() { /* 901 */
        setUpCache() /* 907 */
    }
    
    //MARK: - Public
    
    public func cachedResponse(for endpoint: RMEndpoint, url: URL?) -> Data? { /* 910 */
        guard let targetCache = cacheDictionary[endpoint], let url = url else { /* 911 means:  the targetCache will be in cacheDictionary where endpoint exists */
            return nil /* 912 */
        }
        
        let key = url.absoluteString as NSString /* 913 */
        return targetCache.object(forKey: key) as? Data/* 914 */
    }
    
    public func setCache(for endpoint: RMEndpoint, url: URL?, data: Data) { /* 915 copy from cachedResponse and paste */ /* 917 add data */
        guard let targetCache = cacheDictionary[endpoint], let url = url else { /* 915 */
            return  /* 915 */
        }
        
        let key = url.absoluteString as NSString /* 915 */
        targetCache.setObject(data as NSData, forKey: key) /* 916 */
    }
    
    
    //MARK: - Private
    
    private func setUpCache() { /* 906 */
        RMEndpoint.allCases.forEach({ endpoint in /* 908 */
            cacheDictionary[endpoint] = NSCache<NSString, NSData>() /* 909 means: in dictionary toss in the endpoint and instantiate a new cache object */
        })
    }
}
