//
//  Icons.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 03.08.2024.
//

import Foundation

struct Icons {
    
    var items: [Icon] = [] {
        didSet {
            totalCount = items.count
        }
    }
    var totalCount: Int = 0
}
