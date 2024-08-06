//
//  Dictionary+Ext.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 03.08.2024.
//

import Foundation

extension Dictionary {
    
    func percentEncoded() -> String? {
        
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}
