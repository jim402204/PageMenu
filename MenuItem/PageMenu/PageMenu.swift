//
//  PageMenu.swift
//  MenuItem
//
//  Created by 江俊瑩 on 2020/10/28.
//

import UIKit

class PageMenu {
    
    weak var viewController: UIViewController? = nil

    var menuItem = MenuItem()
    var pageVC = PageVC(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    var vcs: [UIViewController] {
        self.pageVC.viewControllerList
    }
    
    init() {}
    
    /// 設定page menu
    /// - Parameters:
    ///   - viewController: 在哪個vc上顯示
    ///   - menuTitle: 設置上排的titles String
    ///   - viewControllers: 設置下排各個vc分頁
    
    func setUp(_ viewController: UIViewController, menuTitle: [String], viewControllers: [UIViewController]) {

        self.viewController = viewController
        
        //必須先放資料才設置layout
        menuItem = MenuItem(menuTitles: menuTitle)
        print("setUp: \(menuTitle)")
        
        menuItem.delegate = pageVC
        pageVC.setUpMenuItem(menuItem: menuItem, viewControllerList: viewControllers)
        
        setUpUI()
    }
    
}

// MARK: SetUpUI

extension PageMenu {
    
    fileprivate func setUpUI() {
        
        guard let view = viewController?.view else { return }
        
        let menuItem = self.menuItem.collectionView
        
        view.addSubview(menuItem)
        
        menuItem.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuItem.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            menuItem.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            menuItem.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            menuItem.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        viewController?.addChild(pageVC)
        viewController?.view.addSubview(pageVC.view)
        
        guard let pageView = pageVC.view else { return }
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: menuItem.bottomAnchor, constant: 0),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            pageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            pageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        ])
        
        pageVC.didMove(toParent: viewController)
    }
    
}

