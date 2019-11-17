//
//  ISSCollectionViewLayout.swift
//  TaskTable
//
//  Created by Лада on 07/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//

import UIKit

class ISSCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private let numberOfColumns = 1
    private let cellPadding: CGFloat = 1
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
//        if collectionView!.hasActiveDrag {
            layoutAttributes = []
//        }
        
        guard
            let collectionView = collectionView
            else {
                return
        }
        

        let numberOfSections = collectionView.numberOfSections
        let columnWidth = contentWidth / CGFloat(numberOfColumns * numberOfSections )
        var xOffset: [[CGFloat]] = [[]]
        
        for section in 0..<numberOfSections {
            xOffset.append([])
            for column in 0..<numberOfColumns {
                let delta = CGFloat(section * numberOfColumns) * columnWidth + CGFloat(column) * columnWidth
                xOffset[section].append(delta)
            }
        }
        
        for sect in 0..<collectionView.numberOfSections {
            
            var column = 0
            var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
            
        for item in 0..<collectionView.numberOfItems(inSection: sect) {
            let indexPath = IndexPath(item: item, section: sect)
            
            let itemHeight = itemSize.width
            let height = cellPadding * 2 + itemHeight
            var delta = cellPadding * 2
            if item == 0 {
                delta = -0.8*cellPadding 
            }
            let frame = CGRect(x: xOffset[sect][column] + delta,
                               y: yOffset[column],
                               width: columnWidth - 2*delta,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutAttributes.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in layoutAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }

}
