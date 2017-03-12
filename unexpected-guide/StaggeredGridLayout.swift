//
//  StaggeredGridLayout.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 18..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit

protocol StaggeredGridLayoutDelegate {
    func heightForProfileViewAtIndexPath(_ collectionView : UICollectionView,
                                         indexPath : IndexPath,
                                         width : CGFloat) -> CGFloat
    
    func heightForBodyAtIndexPath(_ collectionView : UICollectionView,
                                  indexPath : IndexPath,
                                  width : CGFloat)-> CGFloat
}

class StaggeredGridLayout: UICollectionViewLayout {

    var delegate: StaggeredGridLayoutDelegate! = nil
    
    var cachedAttributes : Array<UICollectionViewLayoutAttributes> = [];

    var contentHeight : CGFloat = 0.0

    let kNumberOfColumns : Int = 2
    let kCellMargin : CGFloat = 5.0

    // MARK: - Accessor
    func contentWidth() -> CGFloat {
        return self.collectionView!.bounds.width - (self.collectionView!.contentInset.left + self.collectionView!.contentInset.right)
    }

    // MARK: - UICollectionViewLayout

    override var collectionViewContentSize : CGSize {
        return CGSize(width: self.contentWidth(), height: self.contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes : Array<UICollectionViewLayoutAttributes> = []
        
        for attribute in self.cachedAttributes {
            if (attribute.frame.intersects(rect)) {
                layoutAttributes.append(attribute)
            }
        }

        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cachedAttributes[indexPath.item]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override func prepare() {
        if self.cachedAttributes.count > 0 {
            return;
        }
        
        var column : Int = 0

        let totalHorizontalMargin : CGFloat = (kCellMargin * (CGFloat(kNumberOfColumns - 1)))
        let cellWidth : CGFloat = (self.contentWidth() - totalHorizontalMargin) / CGFloat(kNumberOfColumns)
        
        var cellOriginXList : Array<CGFloat> = Array<CGFloat>()
        for i in 0..<kNumberOfColumns {
            let originX : CGFloat  = CGFloat(i) * (cellWidth + kCellMargin)
            cellOriginXList.append(originX)
        }

        var currentCellOriginYList : Array<CGFloat> = Array<CGFloat>()
        for _ in 0..<kNumberOfColumns {
            currentCellOriginYList.append(0.0)
        }

        for item in 0..<self.collectionView!.numberOfItems(inSection: 0) {
            let indexPath: IndexPath = IndexPath(row: item, section: 0)

            let profileViewHeight: CGFloat = self.delegate.heightForProfileViewAtIndexPath(self.collectionView!, indexPath: indexPath, width: cellWidth)
            let bodyHeight: CGFloat = self.delegate.heightForBodyAtIndexPath(self.collectionView!, indexPath: indexPath, width: cellWidth)
            let cellHeight: CGFloat = profileViewHeight + bodyHeight;

            let cellFrame: CGRect = CGRect(x: cellOriginXList[column],
                y: currentCellOriginYList[column],
                width: cellWidth,
                height: cellHeight);

            let attributes : StaggeredGridLayoutAttributes = StaggeredGridLayoutAttributes(forCellWith: indexPath)
            attributes.profileViewHeight = profileViewHeight
            attributes.frame = cellFrame;
            self.cachedAttributes.append(attributes)

            self.contentHeight = max(self.contentHeight, cellFrame.maxY);

            currentCellOriginYList[column] = currentCellOriginYList[column] + cellHeight + kCellMargin

            var nextColumn : Int = 0
            var minOriginY : CGFloat = CGFloat.greatestFiniteMagnitude
            let nsCurrentCellOriginYList : NSArray = NSArray(array: currentCellOriginYList)
            nsCurrentCellOriginYList.enumerateObjects({ originY, index, stop in
                if ((originY as! NSNumber).compare(minOriginY as NSNumber) == .orderedAscending) {
                    minOriginY = CGFloat(originY as! NSNumber);
                    nextColumn = index;
                }
            })
            
            column = nextColumn;
        }
    }
}
