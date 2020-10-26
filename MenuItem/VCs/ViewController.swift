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
    let models = [Int](1...10)
    
    lazy var pageVC: PageVC? = { return self.children.first as? PageVC }()
    
    var currentLoaction: CGFloat = 0.0
    var currentRow: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpCollectionView()
        setUpMenuSlider()
        
        pageVC?.scrollView?.delegate = self
    }
    
    

    func setUpCollectionView() {
    
        menuView.delegate = self
        menuView.dataSource = self
        menuView.showsVerticalScrollIndicator = false
        menuView.showsHorizontalScrollIndicator = false
        menuView.register(UINib(nibName: "LabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = menuView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LabelCollectionViewCell
        
        let text = models[indexPath.row]
        item.title.text = "title" + String(text)
        item.title.textColor = .black
        
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.selectItem(at: IndexPath(row: indexPath.row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        //字一樣大才有這個效果   //不一樣大要取得各個item左邊的點在contentOffset的位置
        let result = (collectionView.frame.width / 4.0) * CGFloat(indexPath.row)
        self.leftConstraint?.constant = result
        
        updateMenuViewForMenuSiderAnimate()
        
        // 儲存的位置 供滑動基準。  儲存index 供選擇動畫使用
        self.currentLoaction = result
        self.currentRow = indexPath.row
    }
    
    func updateMenuViewForMenuSiderAnimate() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseIn) {
            self.menuView.layoutIfNeeded()
        } completion: { bool in}
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !(scrollView is UICollectionView) else { return }
    
        guard !(scrollView.contentOffset.x == 375) else { return }
        
        print(scrollView.contentOffset.x)
        
        let unit = (scrollView.contentOffset.x - 375) / 4
        self.leftConstraint?.constant = self.currentLoaction + unit
        
        
        let result = (scrollView.frame.width / 4)
        if scrollView.contentOffset.x == 0 {
            self.currentLoaction = self.currentLoaction - result
            
            self.menuView.selectItem(at: IndexPath(row: currentRow - 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            currentRow -= 1
        } else if scrollView.contentOffset.x == 750 {
            self.currentLoaction = self.currentLoaction + result
            
            self.menuView.selectItem(at: IndexPath(row: currentRow + 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            currentRow += 1
        }
    }
    
}
