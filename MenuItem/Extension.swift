//
//  extension.swift
//  MenuItem
//
//  Created by 江俊瑩 on 2020/10/27.
//

import UIKit

extension String {  //https://www.itread01.com/p/364131.html
    
    //其他都無用吧 先試試這個
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        
        // 在有限的寬 長高
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        //usesLineFragmentOrigin 多行計算  usesFontLeading 行間距計算   => usesDeviceMetrics依據圖型計算而非文字 truncatesLastVisibleLine其他還有最後一行超出變點點點
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font : font], context: nil)
        
        //用來調整view的顯示時 需要無條件進位使用
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {

        // 在有限的寬 長高
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        //usesLineFragmentOrigin 多行計算  usesFontLeading 行間距計算   => usesDeviceMetrics依據圖型計算而非文字 truncatesLastVisibleLine其他還有最後一行超出變點點點
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font : font], context: nil)
        
        //用來調整view的顯示時 需要無條件進位使用
        return ceil(boundingBox.width)
    }
    
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

extension UIView {
    
    func layout(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let view = superview {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: view.topAnchor, constant: top),
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom),
                leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
                rightAnchor.constraint(equalTo: view.rightAnchor, constant: -right),
            ])
        }
    }
}
