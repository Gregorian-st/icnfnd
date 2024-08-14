//
//  ImageLoader.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 04.08.2024.
//

import Foundation
import UIKit.UIImage

final class ImageLoader {
    
    private let cache = ImageCache()
    
    func fetchImage(urlString: String, completion: @escaping (UIImage?, String) -> Void) {
        
        guard let url = URL(string: urlString)
        else {
            completion(nil, urlString)
            return
        }
        
        if let image = cache[url] {
            completion(image, urlString)
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else {
                completion(nil, urlString)
                return
            }
            
            self?.cache[url] = image
            completion(image, urlString)
        }
    }
}
