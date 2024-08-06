//
//  IconsResult.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 03.08.2024.
//

import Foundation

struct IconsResult: Decodable {
    
    var icons = Icons()
    var code: String?
    var message: String?
    
    private let dateFormatterWithMilliseconds: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        return df
    }()
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return df
    }()
    
    enum MainCodingKeys: String, CodingKey {
        case code
        case message
        case totalCount = "total_count"
        case icons
    }
    
    enum IconCodingKeys: String, CodingKey {
        case iconID = "icon_id"
        case tags
        case publishedAt = "published_at"
        case isPremium = "is_premium"
        case type
        case containers
        case rasterSizes = "raster_sizes"
        case styles
        case categories
        case isIconGlyph = "is_icon_glyph"
    }
    
    enum ContainerCodingKeys: String, CodingKey {
        case format
        case downloadURL = "download_url"
    }
    
    enum RasterSizeCodingKeys: String, CodingKey {
        case formats
        case size
        case sizeWidth = "size_width"
        case sizeHeight = "size_height"
    }
    
    enum FormatCodingKeys: String, CodingKey {
        case format
        case previewURL = "preview_url"
        case downloadURL = "download_url"
    }
    
    enum ParameterCodingKeys: String, CodingKey {
        case id = "identifier"
        case name
    }
    
    init(from decoder: Decoder) throws {
        
        let mainContainer = try decoder.container(keyedBy: MainCodingKeys.self)
        do {
            code = try mainContainer.decode(String.self, forKey: .code)
        } catch {}
        
        if let _ = code {
            do {
                message = try mainContainer.decode(String.self, forKey: .message)
            } catch {}
            return
        }
        
        do {
            icons.totalCount = try mainContainer.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0
            var iconsArrayContainer = try mainContainer.nestedUnkeyedContainer(forKey: .icons)
            let iconsCount = iconsArrayContainer.count ?? 0
            for index in 0..<iconsCount {
                let iconContainer = try iconsArrayContainer.nestedContainer(keyedBy: IconCodingKeys.self)
                icons.items.append(Icon())
                icons.items[index].iconID = try iconContainer.decodeIfPresent(Int.self, forKey: .iconID) ?? 0
                icons.items[index].tags = try iconContainer.decodeIfPresent([String].self, forKey: .tags) ?? []
                if let dateString = try iconContainer.decodeIfPresent(String.self, forKey: .publishedAt) {
                    let publishedDateFormatted = dateString.contains(".") ? dateFormatterWithMilliseconds : dateFormatter
                    if let date = publishedDateFormatted.date(from: dateString) {
                        icons.items[index].publishedAt = date
                    }
                }
                icons.items[index].isPremium = try iconContainer.decodeIfPresent(Bool.self, forKey: .isPremium) ?? false
                icons.items[index].type = try iconContainer.decodeIfPresent(String.self, forKey: .type) ?? ""
                
                var containersArrayContainer = try iconContainer.nestedUnkeyedContainer(forKey: .containers)
                let containersCount = containersArrayContainer.count ?? 0
                for indexContainers in 0..<containersCount {
                    let containerContainer = try containersArrayContainer.nestedContainer(keyedBy: ContainerCodingKeys.self)
                    icons.items[index].containers.append(IconContainer())
                    icons.items[index].containers[indexContainers].format = try containerContainer
                        .decodeIfPresent(String.self, forKey: .format) ?? ""
                    icons.items[index].containers[indexContainers].downloadURL = try containerContainer
                        .decodeIfPresent(String.self, forKey: .downloadURL) ?? ""
                }
                
                var rasterArrayContainer = try iconContainer.nestedUnkeyedContainer(forKey: .rasterSizes)
                let rasterCount = rasterArrayContainer.count ?? 0
                var maxSize = 0
                var maxSizeIndex = -1
                for indexRaster in 0..<rasterCount {
                    let rasterContainer = try rasterArrayContainer.nestedContainer(keyedBy: RasterSizeCodingKeys.self)
                    icons.items[index].rasterSizes.append(IconRasterSize())
                    var formatsArrayContainer = try rasterContainer.nestedUnkeyedContainer(forKey: .formats)
                    let formatsCount = formatsArrayContainer.count ?? 0
                    for indexFormat in 0..<formatsCount {
                        let formatContainer = try formatsArrayContainer.nestedContainer(keyedBy: FormatCodingKeys.self)
                        icons.items[index].rasterSizes[indexRaster].formats.append(IconFormat())
                        icons.items[index].rasterSizes[indexRaster].formats[indexFormat].format = try formatContainer
                            .decodeIfPresent(String.self, forKey: .format) ?? ""
                        icons.items[index].rasterSizes[indexRaster].formats[indexFormat].previewURL = try formatContainer
                            .decodeIfPresent(String.self, forKey: .previewURL) ?? ""
                        icons.items[index].rasterSizes[indexRaster].formats[indexFormat].downloadURL = try formatContainer
                            .decodeIfPresent(String.self, forKey: .downloadURL) ?? ""
                    }
                    icons.items[index].rasterSizes[indexRaster].size = try rasterContainer
                        .decodeIfPresent(Int.self, forKey: .size) ?? 0
                    icons.items[index].rasterSizes[indexRaster].sizeWidth = try rasterContainer
                        .decodeIfPresent(Int.self, forKey: .sizeWidth) ?? 0
                    icons.items[index].rasterSizes[indexRaster].sizeHeight = try rasterContainer
                        .decodeIfPresent(Int.self, forKey: .sizeHeight) ?? 0
                    if icons.items[index].rasterSizes[indexRaster].size > maxSize {
                        maxSize = icons.items[index].rasterSizes[indexRaster].size
                        maxSizeIndex = indexRaster
                    }
                }
                icons.items[index].maxRasterSizeIndex = maxSizeIndex
                
                var stylesArrayContainer = try iconContainer.nestedUnkeyedContainer(forKey: .styles)
                let stylesCount = stylesArrayContainer.count ?? 0
                for indexStyles in 0..<stylesCount {
                    let styleContainer = try stylesArrayContainer.nestedContainer(keyedBy: ParameterCodingKeys.self)
                    icons.items[index].styles.append(IconParameter())
                    icons.items[index].styles[indexStyles].id = try styleContainer
                        .decodeIfPresent(String.self, forKey: .id) ?? ""
                    icons.items[index].styles[indexStyles].name = try styleContainer
                        .decodeIfPresent(String.self, forKey: .name) ?? ""
                }
                
                var categoriesArrayContainer = try iconContainer.nestedUnkeyedContainer(forKey: .categories)
                let categoriesCount = categoriesArrayContainer.count ?? 0
                for indexCategories in 0..<categoriesCount {
                    let categoryContainer = try categoriesArrayContainer.nestedContainer(keyedBy: ParameterCodingKeys.self)
                    icons.items[index].categories.append(IconParameter())
                    icons.items[index].categories[indexCategories].id = try categoryContainer
                        .decodeIfPresent(String.self, forKey: .id) ?? ""
                    icons.items[index].categories[indexCategories].name = try categoryContainer
                        .decodeIfPresent(String.self, forKey: .name) ?? ""
                }
                
                icons.items[index].isIconGlyph = try iconContainer.decodeIfPresent(Bool.self, forKey: .isIconGlyph) ?? false
            }
        } catch {
            code = "Parsing error"
            message = "Error parsing icon parameters from server"
        }
    }
}
