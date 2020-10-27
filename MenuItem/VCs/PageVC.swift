//
//  PageVC.swift
//  MenuItem
//
//  Created by 江俊瑩 on 2020/10/23.
//

import UIKit

protocol PageModel {}

class PageVC: UIPageViewController {
    //直接拿也沒有用 這是對應 UIPageViewController內的vcs 需要setViewControllers放入
    var viewControllerList = [UIViewController]()
    fileprivate var models = [PageModel]()
    
    var theLastIndex: Int { return (viewControllerList.count - 1) }
    
    lazy var scrollView: UIScrollView? = { self.view.subviews.first as? UIScrollView }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUPPageVC()
    }
    
    func setUPPageVC() {
        
        self.delegate = self
        self.dataSource = self
    }
    
    //https://www.jianshu.com/p/6762c2b5274a
    
    func setUpVCs<T: Sequence>(models: T) {
       
        var vcs: [UIViewController] = []
        models.forEach({ (model) in
            let vc = UIViewController()
            vc.view.backgroundColor = .random
            
            vcs.append(vc)
        })
        
        self.viewControllerList = vcs
        self.setViewControllers([self.viewControllerList[0]], direction: .forward, animated: true, completion: nil)
    }
    
}

extension PageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex =  self.viewControllerList.firstIndex(of: viewController) else {
            //assertionFailure("index not fuound")
            return viewController
        }
        
        let previousIndex = currentIndex - 1
//        return previousIndex < 0 ?  viewControllerList[self.theLastIndex] : viewControllerList[previousIndex]
        
        return previousIndex < 0 ?  nil : viewControllerList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex =  self.viewControllerList.firstIndex(of: viewController) else {
            //assertionFailure("index not fuound")
            return viewController
        }
        
        let nextIndex = currentIndex + 1
//        return nextIndex > self.theLastIndex ? viewControllerList[0] : viewControllerList[nextIndex]
        
        return nextIndex > self.theLastIndex ? nil : viewControllerList[nextIndex]
    }
    
}


extension PageVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        //翻頁結束 堆疊的第一個是當前的 頁面
        let currentViewController = self.viewControllers?.first ?? self.viewControllerList[0]
        guard let currentIndex =  self.viewControllerList.firstIndex(of: currentViewController) else { //assertionFailure("index not fuound")
            return
        }
        
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
