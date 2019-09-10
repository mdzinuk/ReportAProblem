//
//  LayoutAttributes.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 20/10/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit

final class LayoutAttributes: UICollectionViewLayoutAttributes {
    var parallax: CGAffineTransform = .identity
    var initialOrigin: CGPoint = .zero
    var headerOverlayAlpha = CGFloat(0)
    
    override func copy(with zone: NSZone?) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? LayoutAttributes else {
            return super.copy(with: zone)
        }
        
        copiedAttributes.parallax = parallax
        copiedAttributes.initialOrigin = initialOrigin
        copiedAttributes.headerOverlayAlpha = headerOverlayAlpha
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? LayoutAttributes else {
            return false
        }
        
        if NSValue(cgAffineTransform: otherAttributes.parallax) != NSValue(cgAffineTransform: parallax)
            || otherAttributes.initialOrigin != initialOrigin
            || otherAttributes.headerOverlayAlpha != headerOverlayAlpha {
            return false
        }
        
        return super.isEqual(object)
    }
}
