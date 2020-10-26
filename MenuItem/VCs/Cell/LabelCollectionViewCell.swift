//
//  LabelCollectionViewCell.swift
//  MenuItem
//
//  Created by 江俊瑩 on 2020/10/23.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 選擇文字 顯示顏色
        title.highlightedTextColor = .systemRed
    }

}


