//
//  Icon.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 03.08.2024.
//

import Foundation

import Foundation

struct Icon {
    
    var iconID: Int = 0
    var tags: [String] = []
    var publishedAt = Date()
    var isPremium: Bool = false
    var type = String()
    var containers: [IconContainer] = []
    var rasterSizes: [IconRasterSize] = []
    var maxRasterSizeIndex: Int?
    var styles: [IconParameter] = []
    var categories: [IconParameter] = []
    var isIconGlyph: Bool = false
}

struct IconContainer {
    
    var format = String()
    var downloadURL = String()
}

struct IconRasterSize {
    
    var formats: [IconFormat] = []
    var size: Int = 0
    var sizeWidth: Int = 0
    var sizeHeight: Int = 0
}

struct IconFormat {
    
    var format = String()
    var previewURL = String()
    var downloadURL = String()
}

struct IconParameter {
    
    var id = String()
    var name = String()
}
