//
//  StaggeredGridLayoutAttributes.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 18..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit

open class StaggeredGridLayoutAttributes: UICollectionViewLayoutAttributes {
    open var profileViewHeight : CGFloat = 0.0

    open override func copy(with zone: NSZone?) -> Any {
        let copy : StaggeredGridLayoutAttributes = super.copy(with: zone) as! StaggeredGridLayoutAttributes
        copy.profileViewHeight = self.profileViewHeight;
        
        return copy;
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        if object is StaggeredGridLayoutAttributes {
            let attributtes : StaggeredGridLayoutAttributes = object as! StaggeredGridLayoutAttributes

            if (attributtes.profileViewHeight == self.profileViewHeight) {
                return super.isEqual(attributtes)
            }
        }
        return false;
    }
}
