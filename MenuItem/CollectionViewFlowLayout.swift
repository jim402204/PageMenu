//
//  CollectionViewFlowLayout.swift
//  MenuItem
//
//  Created by 江俊瑩 on 2020/10/26.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    //滾動變形的 選true
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
//    override var collectionViewContentSize: CGSize {
//        let size = super.collectionViewContentSize
//        return CGSize(width: size.width, height: size.height)
//    }
//
//    //section
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let attributes = super.layoutAttributesForElements(in: rect)
//
//        guard let attributesArray = attributes else { return nil }
//
//        return attributesArray
//    }
    
    
    
    // cell 的cellForRow
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
       
        return attributes
    }
    
    //cell 的reused 重新載入
    override func prepare() {
        super.prepare()
        
        
    }
    
    
}
