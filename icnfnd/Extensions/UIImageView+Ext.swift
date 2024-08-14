//
//  UIImageView+Ext.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 14.08.2024.
//

import UIKit

private var imageURLAssociationKey: UInt8 = 0

extension UIImageView {
    
    var imageURL: String? {
        get {
            return objc_getAssociatedObject(self, &imageURLAssociationKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &imageURLAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
