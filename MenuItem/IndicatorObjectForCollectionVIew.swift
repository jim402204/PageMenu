//
//  IndicatorObjectForCollectionVIew.swift
//  DBJ2
//
//  Created by 江俊瑩 on 2021/5/20.
//

import UIKit

class IndicatorObject {
    
    var indicator: UIView
    
    var indicatorWidth: CGFloat
    var cellWidth: CGFloat
    var insets: UIEdgeInsets
    var animateDuration = 0.25
    
    
    init(view: UIView, cellWidth: CGFloat, insets: UIEdgeInsets = .zero) {
        self.indicator = view
        self.cellWidth = cellWidth
        self.insets = insets
        self.indicatorWidth = indicator.frame.width
        
        indicator.backgroundColor = .systemBlue
        
        if view.frame.origin == .zero {
            indicator.frame.origin = CGPoint(x: 0, y: 40)
        }
        if view.frame.size == .zero {
            
            let defaultCellWidth = cellWidth * (2/3)
            indicator.frame.size = CGSize(width: defaultCellWidth, height: 5)
            indicatorWidth = defaultCellWidth
        }
        // view 置中算法
        let firstX = (cellWidth - indicatorWidth) / 2
        indicator.transform = CGAffineTransform(translationX: (insets.left + firstX), y: 0)
    }
    
    func didSelectItemAt(cell: UICollectionViewCell?) {
        
        guard let cellMidX = cell?.frame.midX else { return }
        
        UIView.animate(withDuration: animateDuration, animations: { () -> Void in

            let centerX = cellMidX - (self.indicator.frame.width / 2)
            
            self.indicator.transform = CGAffineTransform(translationX: centerX, y: 0)
        })
    }
    
    
    func test() {
        //加到collection中後 用frame設置位置跟移動 didSelectItemAt 取的cell的frame去算中心點 注意init frame要=0
        
//        collectionView.addSubview(indicatorObject.indicator)
//
//        lazy var indicatorObject: IndicatorObject = {
//            let rect = CGRect(origin: CGPoint(x: 0, y: 35), size: CGSize(width: 40, height: 5))
//            return IndicatorObject(view: UIView(frame: rect),cellWidth: cellWidth,insets: insets)
//        }()
        
//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//            let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell
//
//            indicatorObject.didSelectItemAt(cell: cell)
//        }
    }
    
}
