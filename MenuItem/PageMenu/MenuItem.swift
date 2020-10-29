//
//  MenuItem.swift
//  MenuItem
//
//  Created by 江俊瑩 on 2020/10/28.
//

import UIKit

protocol MenuItemDelegate: AnyObject {
    func collectionViewDidSelectItem(at indexPath: IndexPath)
}

class MenuItem: NSObject {
    
    weak var delegate: MenuItemDelegate? = nil
    
    var collectionView = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewLayout())
    
    //menu slider bar NSLayoutConstraint
    var leftAnchor: NSLayoutConstraint? = nil
    var widthAnchor: NSLayoutConstraint? = nil
    
    var menuTitles: [String] = []
    let menuTextHeight: CGFloat = 40
    lazy var firstMenuWidth = { self.getTextWidth(indexPath: IndexPath(row: 0, section: 0)) }()
    /// 載入item時候儲存
    var offsetX: [Int:CGFloat] = [:]
    var sliderWidth: [Int:CGFloat] = [:]
    var currentLoaction: CGFloat = 0.0
    var currentRow: Int = 0
    
    override init() {
        super.init()
    }
    
    init(menuTitles: [String]) {
        super.init()
        self.menuTitles = menuTitles
        
        self.setUpCollectionView()
        self.setUpMenuSlider()
    }
    
    func setting(menuTitles: [String]) {
        
        self.menuTitles = menuTitles
        setUpCollectionView()
        setUpMenuSlider()
    }
    
}

// MARK: SetUp

extension MenuItem {
    
    func setUpCollectionView() {
    
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: "LabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .white
        
        
        //https://stackoverflow.com/questions/51585879/uicollectionviewcell-dynamic-height-w-two-dynamic-labels-auto-layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        // 注意item跟collection對應的大小 間距設置為0確保顯示為一行
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal

        collectionView.collectionViewLayout = layout
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        
    }
    
    func setUpMenuSlider() {
        
        //layout 要配置為scrollView
        
        let slider = UIView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(slider)
        
        slider.backgroundColor = .blue
        
        slider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        slider.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor,constant: 16).isActive = true
          
        widthAnchor = slider.widthAnchor.constraint(equalToConstant: firstMenuWidth)
        
        widthAnchor?.isActive = true
        leftAnchor = slider.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 0)
        leftAnchor?.isActive = true
    }
    
}

// MARK: UICollectionView

extension MenuItem: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LabelCollectionViewCell
        
        let text = menuTitles[indexPath.row]
        item.title.text = String(text)
        item.title.textColor = .black
        
        
        let itemAttributes = self.collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)
        let itemContentOffset = itemAttributes?.frame.minX
        
        offsetX[indexPath.row] = itemContentOffset
        sliderWidth[indexPath.row] = itemAttributes?.frame.width
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.selectItem(at: IndexPath(row: indexPath.row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        moveMenuSlider(collectionView: collectionView, indexPath)
        
        movePageVC(to: indexPath)
        
        updateMenuViewForMenuSiderAnimate()
    }
    
    fileprivate func moveMenuSlider(collectionView: UICollectionView, _ indexPath: IndexPath) {
        
        //直接取得 item對應的contentoffset 的frame
        let itemAttributes = self.collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) //item object

        let defaultWidth = getItemContentOffsetWidth(collectionView: collectionView, indexPath)
        let itemContentOffset = itemAttributes?.frame.minX ?? defaultWidth
        let itemWidth = itemAttributes?.frame.width ?? firstMenuWidth
        
        self.leftAnchor?.constant = itemContentOffset
        self.widthAnchor?.constant = itemWidth
        
        // 儲存的位置 供滑動基準。  儲存index 供選擇動畫使用
        self.currentLoaction = itemContentOffset
        self.currentRow = indexPath.row
    }
    
    fileprivate func updateMenuViewForMenuSiderAnimate() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseIn) {
            self.collectionView.layoutIfNeeded()
        } completion: { bool in}
    }
    
    fileprivate func getItemContentOffsetWidth(collectionView: UICollectionView, _ indexPath: IndexPath) -> CGFloat {
        //字一樣大才有這個效果   //不一樣大要取得各個item左邊的點在contentOffset的位置
        let result = (collectionView.frame.width / 4.0) * CGFloat(indexPath.row)
        return result
    }
    
    func movePageVC(to indexPath: IndexPath) {
        delegate?.collectionViewDidSelectItem(at: indexPath)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension MenuItem: UICollectionViewDelegateFlowLayout { //delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = getTextWidth(indexPath: indexPath)
        return CGSize(width: width, height: menuTextHeight)
    }
    
    func getTextWidth(indexPath: IndexPath) -> CGFloat {
        //取得動態title寬度
        let width = menuTitles[indexPath.row].width(withConstrainedHeight: menuTextHeight, font: UIFont.systemFont(ofSize: 17)) + 20 //(左右間距)
        print("\(indexPath.row)  \(width)")
        return width
    }
    
}
