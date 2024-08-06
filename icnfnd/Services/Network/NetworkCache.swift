//
//  NetworkCache.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 05.08.2024.
//

import Foundation

final class NetworkCache {
    
    private lazy var requestCache: [String:IconsResult] = [:]
    
    private let lock = NSLock()
}

extension NetworkCache {
    
    func insertRequest(_ iconsResult: IconsResult?, for request: String) {
        
        guard let iconsResult = iconsResult
        else { return removeRequest(for: request) }
        
        lock.lock()
        defer { lock.unlock() }
        requestCache[request] = iconsResult
    }

    func removeRequest(for request: String) {
        
        lock.lock()
        defer { lock.unlock() }
        requestCache.removeValue(forKey: request)
    }
    
    subscript(_ key: String) -> IconsResult? {
        
        get {
            return requestCache[key]
        }
        set {
            return insertRequest(newValue, for: key)
        }
    }
}
