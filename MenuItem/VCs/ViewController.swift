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
    
    var leftConstraint: NSLayoutConstraint? = nil
    let menuModeld = ["芭蕉","旦蕉","金鑽鳳梨","鳳梨花","蓬萊仙山999","甜蜜蜜","檸檬","牛奶鳳梨","葡萄柚","柚子"]
    
    lazy var pageVC: PageVC? = { return self.children.first as? PageVC }()
    
    var currentLoaction: CGFloat = 0.0
    var currentRow: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpCollectionView()
        setUpMenuSlider()
        
        pageVC?.scrollView?.delegate = self
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
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        //如果要浮動item size 需要覆寫 layotut attribute 方法
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: 40)
        layout.minimumLineSpacing = 0.3
        layout.scrollDirection = .horizontal
        menuView.decelerationRate = .fast
        menuView.collectionViewLayout = layout
    }
    
    func setUpMenuSlider() {
        
        let slider = UIView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(slider)
        
        slider.backgroundColor = .blue
        slider.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier: 1/4) .isActive = true
        slider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        slider.centerYAnchor.constraint(equalTo: menuView.centerYAnchor,constant: 16).isActive = true
        
        leftConstraint = slider.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 0)
        leftConstraint?.isActive = true
    }
    
}


// MARK: UICollectionView

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuModeld.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = menuView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LabelCollectionViewCell
        
        let text = menuModeld[indexPath.row]
        item.title.text = String(text)
        item.title.textColor = .black
        
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.selectItem(at: IndexPath(row: indexPath.row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        //直接取得 item對應的contentoffset 的frame
        let itemAttributes = self.menuView.collectionViewLayout.layoutAttributesForItem(at: indexPath) //item object
        print("itemAttributes: \(String(describing: itemAttributes?.frame.minX))")

        let defaultWidth = getItemContentOffsetWidth(collectionView: collectionView, indexPath)
        let itemContentOffset = itemAttributes?.frame.minX ?? defaultWidth
        
        self.leftConstraint?.constant = itemContentOffset
        
        
        updateMenuViewForMenuSiderAnimate()
        
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
    
}

// MARK: UIScrollView

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let screenWidth = UIScreen.main.bounds.width
        //擋掉上面 UICollectionView 的滾動
        guard !(scrollView is UICollectionView) else { return }
        //擋掉page offset 歸零的判斷
        guard !(scrollView.contentOffset.x == screenWidth) else { return }
        print(scrollView.contentOffset.x)
        
        menuSliderBarMove(scrollView, screenWidth: screenWidth)
        
        itemSelection(scrollView,screenWidth: screenWidth)
    }
    
    func menuSliderBarMove(_ scrollView: UIScrollView, screenWidth: CGFloat) {
        
        //取得得是滾完的位置 需要 - item本身的width
        let endLoacation = (scrollView.contentOffset.x - screenWidth) / 4
        self.leftConstraint?.constant = self.currentLoaction + endLoacation
    }
    
    func itemSelection(_ scrollView: UIScrollView, screenWidth: CGFloat) {
        
        //item本身的width
        let itemWidth = (scrollView.frame.width / 4)
        
        if scrollView.contentOffset.x == 0 {
            
            self.currentLoaction = self.currentLoaction - itemWidth
            scrollToCenteredHorizontally(currentRow: (currentRow - 1))
            
        } else if scrollView.contentOffset.x == (screenWidth + screenWidth) {
            
            self.currentLoaction = self.currentLoaction + itemWidth
            scrollToCenteredHorizontally(currentRow: (currentRow + 1))
        }
    }
    
    fileprivate func scrollToCenteredHorizontally(currentRow: Int) {
        self.menuView.selectItem(at: IndexPath(row: currentRow, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        self.currentRow = currentRow
    }
    
}
