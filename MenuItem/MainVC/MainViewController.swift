//
//  MainViewController.swift
//  MenuItem
//
//  Created by 江俊瑩 on 2020/10/28.
//

import UIKit

class MainViewController: UIViewController {

    let menuModels = ["芭蕉","旦蕉","金鑽鳳梨","鳳梨花","蓬萊仙山999","甜蜜蜜","檸檬","牛奶鳳梨","葡萄柚","柚子"]
    
    let viewControllers: [UIViewController] = []
    
    var pageMenu = PageMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageMenu.setUp(self,menuTitle: menuModels, viewControllers: viewControllers)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
   

}
