//
//  ViewController.swift
//  MenuItem
//
//  Created by 江俊瑩 on 2020/10/22.
//

import UIKit

//https://github.com/rechsteiner/Parchment
//https://github.com/yysskk/SwipeMenuViewController

class ViewController: UIViewController {

    @IBOutlet weak var menuView: UICollectionView!
    //menu slider bar NSLayoutConstraint
    var leftAnchor: NSLayoutConstraint? = nil
    var widthAnchor: NSLayoutConstraint? = nil
    
    let menuModels = ["芭蕉","旦蕉","金鑽鳳梨","鳳梨花","蓬萊仙山999","甜蜜蜜","檸檬","牛奶鳳梨","葡萄柚","柚子"]
    
    lazy var pageVC: PageVC? = { return self.children.first as? PageVC }()
    
    
    // menu object
    let menuTextHeight: CGFloat = 40
    lazy var firstMenuWidth = { self.getTextWidth(indexPath: IndexPath(row: 0, section: 0)) }()
    
    var menuItemOffsetX: [Int:CGFloat] = [:]
    var menuItemWidth: [Int:CGFloat] = [:]
    
    var currentLoaction: CGFloat = 0.0
    var currentRow: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpCollectionView()
        setUpMenuSlider()
        
        pageVC?.scrollView?.delegate = self
        pageVC?.setUpVCs(models: menuModels)
    }
    
}

// MARK: setUpView

extension ViewController {
    
    func setUpCollectionView() {
    
        menuView.delegate = self
        menuView.dataSource = self
        menuView.showsVerticalScrollIndicator = false
        menuView.showsHorizontalScrollIndicator = false
        menuView.register(UINib(nibName: "LabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        menuView.decelerationRate = .fast
        
        
        
        //https://stackoverflow.com/questions/51585879/uicollectionviewcell-dynamic-height-w-two-dynamic-labels-auto-layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: 40)

        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.itemSize = UICollectionViewFlowLayout.automaticSize
//
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .horizontal
        
        menuView.collectionViewLayout = layout
        menuView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        
        
        
//        var contentSize: CGFloat = 0.0
//
//        for (index,item) in menuModels.enumerated() {
//            let width = menuModels[index].width(withConstrainedHeight: menuTextHeight, font: UIFont.systemFont(ofSize: 17)) + 20 //(左右間距)
//            contentSize += width
//        }
//
//        menuView.contentSize = CGSize(width: contentSize, height: menuView.contentSize.height)
//
//        menuView.reloadData()
        
//        layout.invalidateLayout()
//        menuView.layoutIfNeeded()
//        menuView.reloadData()
        
    }
    
    func setUpMenuSlider() {
        
        //layout 要配置為scrollView
        
        let slider = UIView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(slider)
        
        slider.backgroundColor = .blue
        
        slider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        slider.centerYAnchor.constraint(equalTo: menuView.centerYAnchor,constant: 16).isActive = true
        
//        widthAnchor = slider.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier: 1/4)
        
        widthAnchor = slider.widthAnchor.constraint(equalToConstant: firstMenuWidth)
        widthAnchor?.isActive = true
        leftAnchor = slider.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 0)
        leftAnchor?.isActive = true
    }
    
}

// MARK: UICollectionView

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = menuView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LabelCollectionViewCell
        
        let text = menuModels[indexPath.row]
        item.title.text = String(text)
        item.title.textColor = .black
        
        
        let itemAttributes = self.menuView.collectionViewLayout.layoutAttributesForItem(at: indexPath)
        let itemContentOffset = itemAttributes?.frame.minX
        
        menuItemOffsetX[indexPath.row] = itemContentOffset
        menuItemWidth[indexPath.row] = itemAttributes?.frame.width
        
//        item.cellWidth.constant = CGFloat((text.count * 30)) //使用nib autolayout
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.selectItem(at: IndexPath(row: indexPath.row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        
        moveMenuSlider(collectionView: collectionView, indexPath)
        
        movePageVC(to: indexPath)
        
        updateMenuViewForMenuSiderAnimate()
    }
    
    func moveMenuSlider(collectionView: UICollectionView, _ indexPath: IndexPath) {
        
        //直接取得 item對應的contentoffset 的frame
        let itemAttributes = self.menuView.collectionViewLayout.layoutAttributesForItem(at: indexPath) //item object
//        print("itemAttributes: \(String(describing: itemAttributes?.frame.minX))")

        let defaultWidth = getItemContentOffsetWidth(collectionView: collectionView, indexPath)
        let itemContentOffset = itemAttributes?.frame.minX ?? defaultWidth
        let itemWidth = itemAttributes?.frame.width ?? firstMenuWidth
        
        self.leftAnchor?.constant = itemContentOffset
        self.widthAnchor?.constant = itemWidth
        
        // 儲存的位置 供滑動基準。  儲存index 供選擇動畫使用
        self.currentLoaction = itemContentOffset
        self.currentRow = indexPath.row
    }
    
    func updateMenuViewForMenuSiderAnimate() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseIn) {
            self.menuView.layoutIfNeeded()
        } completion: { bool in}
    }
    
    func getItemContentOffsetWidth(collectionView: UICollectionView, _ indexPath: IndexPath) -> CGFloat {
        //字一樣大才有這個效果   //不一樣大要取得各個item左邊的點在contentOffset的位置
        let result = (collectionView.frame.width / 4.0) * CGFloat(indexPath.row)
        return result
    }
    
    func movePageVC(to indexPath: IndexPath) {
        
        if let pageVC = self.pageVC {
            let displayVC = pageVC.viewControllerList[indexPath.row]
            pageVC.setViewControllers([displayVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout { //delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = getTextWidth(indexPath: indexPath)
        return CGSize(width: width, height: menuTextHeight)
    }
    
    func getTextWidth(indexPath: IndexPath) -> CGFloat {
        //取得動態title寬度
        let width = menuModels[indexPath.row].width(withConstrainedHeight: menuTextHeight, font: UIFont.systemFont(ofSize: 17)) + 20 //(左右間距)
        print("\(indexPath.row)  \(width)")
        return width
    }
    
}

// MARK: UIScrollView

extension ViewController: UIScrollViewDelegate {
    
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
        let currentWidth = menuItemWidth[currentRow] ?? firstMenuWidth
        
        
        // pageVC的行為： 0 - 1 - 2 （* 375） 到末端後回歸375
        let directionCondition = ((scrollView.contentOffset.x / UIScreen.main.bounds.width) - 1)
        let leftMove = directionCondition > 0
        let rightMove = directionCondition < 0
        
        if leftMove {
            
            widthUnit = currentWidth
            nextWidth = menuItemWidth[currentRow + 1] ?? currentWidth
            
        } else if rightMove {

            widthUnit = menuItemWidth[currentRow - 1] ?? currentWidth
            nextWidth = menuItemWidth[currentRow - 1] ?? currentWidth
        }
        
        //偏移量 / 移動的距離 -1個單位 ＊ 單位量  //取得得是滾完的位置 需要 - item本身的width
        let endLoacation = ((scrollView.contentOffset.x / UIScreen.main.bounds.width) - 1) * widthUnit
        self.leftAnchor?.constant = self.currentLoaction + endLoacation
        
        //滑動變化率必須要為正的
        let varyingWidth  = abs((scrollView.contentOffset.x / UIScreen.main.bounds.width) - 1) * (nextWidth - currentWidth)
        self.widthAnchor?.constant = currentWidth + varyingWidth
    }
    
    func itemSelection(_ scrollView: UIScrollView, screenWidth: CGFloat) { //判斷翻頁 左右
      
        if scrollView.contentOffset.x == 0 {
        
            scrollToCenteredHorizontally(currentRow: (currentRow - 1))
            
        } else if scrollView.contentOffset.x == (screenWidth + screenWidth) {
            
            scrollToCenteredHorizontally(currentRow: (currentRow + 1))
        }
    }
    
    fileprivate func scrollToCenteredHorizontally(currentRow: Int) { //動畫是要原本的 index
        self.menuView.selectItem(at: IndexPath(row: currentRow, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        self.currentRow = currentRow
        //儲存上一個位置
        self.currentLoaction = menuItemOffsetX[currentRow] ?? 0.0
    }
    
}
