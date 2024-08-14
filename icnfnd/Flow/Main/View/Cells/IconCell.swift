//
//  IconCell.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 04.08.2024.
//

import UIKit

final class IconCell: UITableViewCell {
    
    weak var imageLoader: ImageLoader?
    
    var icon: Icon? {
        didSet {
            iconImageView.image = nil
            
            if let icon = icon {
                tagsLabel.text = getTags(tags: icon.tags, maxCount: 10)
            } else {
                tagsLabel.text = ""
            }

            if let maxSizeIndex = icon?.maxRasterSizeIndex {
                let rasterSize = icon?.rasterSizes[maxSizeIndex]
                sizeLabel.text = "Max Size - Width: \(rasterSize?.sizeWidth ?? 0) Height: \(rasterSize?.sizeHeight ?? 0)"
            } else {
                sizeLabel.text = "Max Size not found"
            }
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.layer.cornerRadius = 15
            iconImageView.layer.masksToBounds = true
            iconImageView.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    // MARK: - Logic
    
    private func getTags(tags: [String], maxCount: Int) -> String {
        
        let itemsCount = min(tags.count, maxCount)
        return itemsCount == 0 ? "No Tags found!" : tags[0..<itemsCount].joined(separator: ", ")
    }
}
