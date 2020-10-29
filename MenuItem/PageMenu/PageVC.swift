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
    
    fileprivate func setUPPageVC() {
        
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
    
    //提供collectionView的資料對應滑動
    var menuItem = MenuItem()
    
    func setUpMenuItem(menuItem: MenuItem, viewControllerList: [UIViewController]) {
        self.menuItem = menuItem
        
        scrollView?.delegate = self
        
        setUp(viewControllers: viewControllerList)
    }
    
    func setUp(viewControllers: [UIViewController]) {
       
        self.viewControllerList = viewControllers
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


// MARK: UIScrollView

extension PageVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let screenWidth = UIScreen.main.bounds.width
        //擋掉上面 UICollectionView 的滾動
        guard !(scrollView is UICollectionView) else { return }
        //擋掉page offset 歸零的判斷
        guard !(scrollView.contentOffset.x == screenWidth) else { return }
        
        menuSliderBarMove(scrollView, screenWidth: screenWidth)
        
        itemSelection(scrollView,screenWidth: screenWidth)
    }
    
    func menuSliderBarMove(_ scrollView: UIScrollView, screenWidth: CGFloat) {
        
        var widthUnit: CGFloat = 0.0
        var nextWidth: CGFloat = 0.0
        let currentWidth = menuItem.sliderWidth[menuItem.currentRow] ?? menuItem.firstMenuWidth
        
        // pageVC的行為： 0 - 1 - 2 （* 375） 到末端後回歸375
        let directionCondition = ((scrollView.contentOffset.x / UIScreen.main.bounds.width) - 1)
        let leftMove = directionCondition < 0
        let rightMove = directionCondition > 0
        
        if rightMove {
            
            widthUnit = currentWidth
            nextWidth = menuItem.sliderWidth[menuItem.currentRow + 1] ?? currentWidth
            
        } else if leftMove {

            widthUnit = menuItem.sliderWidth[menuItem.currentRow - 1] ?? currentWidth
            nextWidth = menuItem.sliderWidth[menuItem.currentRow - 1] ?? currentWidth
        }
        
        //偏移量 / 移動的距離 -1個單位 ＊ 單位量  //取得得是滾完的位置 需要 - item本身的width
        var endLoacation = ((scrollView.contentOffset.x / UIScreen.main.bounds.width) - 1) * widthUnit
        endLoacation = setUpSpaceing(leftMove: leftMove, rightMove: rightMove, endLoacation: &endLoacation)
        
        menuItem.leftAnchor?.constant = menuItem.currentLoaction + endLoacation
        
        //滑動變化率必須要為正的
        let varyingWidth  = abs((scrollView.contentOffset.x / UIScreen.main.bounds.width) - 1) * (nextWidth - currentWidth)
        menuItem.widthAnchor?.constant = currentWidth + varyingWidth
    }
    
    //判斷翻頁 左右
    fileprivate func itemSelection(_ scrollView: UIScrollView, screenWidth: CGFloat) {
      
        if scrollView.contentOffset.x == 0 {
        
            selectionScrollTo(currentRow: (menuItem.currentRow - 1))
            
        } else if scrollView.contentOffset.x == (screenWidth + screenWidth) {
            
            selectionScrollTo(currentRow: (menuItem.currentRow + 1))
        }
    }
    
    //動畫是要原本的 index
    fileprivate func selectionScrollTo(currentRow: Int) {
        menuItem.collectionView.selectItem(at: IndexPath(row: currentRow, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        menuItem.currentRow = currentRow
        
        //拖動邊緣判斷
        guard currentRow >= 0 &&  currentRow <= menuItem.menuTitles.count  else { return }
        //儲存上一個位置
        menuItem.currentLoaction = menuItem.offsetX[currentRow] ?? 0.0
    }
    
    fileprivate func setUpSpaceing(leftMove: Bool, rightMove: Bool, endLoacation : inout CGFloat) -> CGFloat {

        //左右距離補償
        let flowLayout = menuItem.collectionView.collectionViewLayout as? UICollectionViewFlowLayout

        if let minimumSpacing = flowLayout?.minimumLineSpacing, minimumSpacing > 0 {

            if rightMove {
                endLoacation += minimumSpacing
            } else if leftMove {
                endLoacation -= minimumSpacing
            }
        }
        return endLoacation
    }
    
}

extension PageVC: MenuItemDelegate {
    
    func collectionViewDidSelectItem(at indexPath: IndexPath) {
        
        let displayVC = viewControllerList[indexPath.row]
        setViewControllers([displayVC], direction: .forward, animated: false, completion: nil)
    }
    
}
