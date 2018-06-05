//
//  ItemListViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit


class ItemListViewController: UIViewController {

    @IBOutlet weak var itemCategoryCollectionView: UICollectionView!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuView: UIView!
    var isSideMenuHidden = true
    
    let categoryVCs = [TotalViewController(), FoodViewController(), MedicineViewController(), MakeupViewController(), NecessaryViewController(), OthersViewController()]
    let list: [String] = [ListCategory.total.rawValue, ListCategory.food.rawValue, ListCategory.medicine.rawValue, ListCategory.makeup.rawValue, ListCategory.necessary.rawValue, ListCategory.others.rawValue]
    var itemListChildViewControllers: [UIViewController] = []
    var selectedBooling: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        setNavBackground()
        
        sideMenuConstraint.constant = -300
        setupSideMenu()
        self.view.bringSubview(toFront: sideMenuView)
        
        let notificationName = Notification.Name("AddItem")
        NotificationCenter.default.addObserver(self, selector: #selector(updateNewItem(noti:)), name: notificationName, object: nil)
        
        itemCategoryCollectionView.showsHorizontalScrollIndicator = false
        
        itemCategoryCollectionView.delegate = self
        itemCategoryCollectionView.dataSource = self
        
        registerCell()

    }
    
    func setupSideMenu() {
        sideMenuView.layer.shadowColor = UIColor.black.cgColor
        sideMenuView.layer.shadowOpacity = 0.3
        sideMenuView.layer.shadowOffset = CGSize(width: 5, height: 0)
    }
    
    @IBAction func sideMenuAction(_ sender: UIBarButtonItem) {
        
        if isSideMenuHidden {
            itemCategoryCollectionView.isUserInteractionEnabled = false
//            itemListScrollView.isUserInteractionEnabled = false
            sideMenuView.isUserInteractionEnabled = true
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
            swipeLeft.direction = .left
            sideMenuConstraint.constant = 0
            sideMenuView.addGestureRecognizer(swipeLeft)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            itemCategoryCollectionView.isUserInteractionEnabled = true
//            itemListScrollView.isUserInteractionEnabled = true
            sideMenuConstraint.constant = -300
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        isSideMenuHidden = !isSideMenuHidden
    }
    
    @objc func swipe(recognizer: UISwipeGestureRecognizer) {
        let point = self.view.center
        if recognizer.direction == .left {
            if point.x >= 150 {
                sideMenuConstraint.constant = -300
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                itemCategoryCollectionView.isUserInteractionEnabled = true
//                itemListScrollView.isUserInteractionEnabled = true
                isSideMenuHidden = !isSideMenuHidden
            }
        }
    }
//}




    func setNavBackground() {
        navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
        navigationController?.navigationBar.layer.shadowRadius = 5
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    }

    private func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = navigationController?.navigationBar.bounds
        // take into account the status bar
        updatedFrame?.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(
            bounds: updatedFrame!,
            color1: UIColor.white,
            color2: UIColor.white
        )
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    // for zoom in/out collectionview cell
    func animateZoomforCell(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: {
                zoomCell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },
            completion: nil)
    }
    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: {
                zoomCell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        },
            completion: nil)
    }
    
    func registerCell() {
        let upnib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        itemCategoryCollectionView.register(upnib, forCellWithReuseIdentifier: "CategoryCollectionCell")
    }
    
    func setupListGridView() {
        let screenSize = UIScreen.main.bounds
        if let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            categoryCollectionViewFlowLayout.itemSize = CGSize(width: screenSize.width / 2, height: itemCategoryCollectionView.frame.height)
            categoryCollectionViewFlowLayout.minimumInteritemSpacing = 0
            categoryCollectionViewFlowLayout.minimumLineSpacing = 10
            let categoryCollectionViewSectionInset = screenSize.width / 4
            categoryCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: categoryCollectionViewSectionInset, bottom: 10, right: categoryCollectionViewSectionInset)
        }
    }
    
    // MARK: - FOR UPDATE NEW ITEM -
    @objc func updateNewItem(noti: Notification) {
        guard let data = noti.userInfo!["PASS"] as? ItemList else { return }
        switch data.category {
        case ListCategory.total.rawValue:
            updateItemList(data: data, index: 0)
        case ListCategory.food.rawValue:
            updateItemList(data: data, index: 0)
            updateItemList(data: data, index: 1)
        case ListCategory.medicine.rawValue:
            updateItemList(data: data, index: 0)
            updateItemList(data: data, index: 2)
        case ListCategory.makeup.rawValue:
            updateItemList(data: data, index: 0)
            updateItemList(data: data, index: 3)
        case ListCategory.necessary.rawValue:
            updateItemList(data: data, index: 0)
            updateItemList(data: data, index: 4)
        case ListCategory.others.rawValue:
            updateItemList(data: data, index: 0)
            updateItemList(data: data, index: 5)
        default:
            break
        }
    }
    
    private func updateItemList(data: ItemList, index: Int) {
        if let itemChildVC = itemListChildViewControllers[index] as? ItemCategoryViewController {
            itemChildVC.items.append(data)
            itemChildVC.items.sort { $0.createDate > $1.createDate }
            itemChildVC.categoryView.itemTableView.reloadData()
        }
    }
    
}


extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath as IndexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.categoryLabel.text = list[indexPath.row]
        setupListGridView()
        
        if selectedBooling == [] {
            selectedBooling.append(true)
            for _ in 1...list.count {
                selectedBooling.append(false)
            }
        }
        if selectedBooling[indexPath.item] {
            cell.categoryLabel.textColor = UIColor.white
        } else {
            cell.categoryLabel.textColor = UIColor.lightGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        guard let cell = itemCategoryCollectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
////        animateZoomforCell(zoomCell: cell)
//
//        let itemNum = indexPath.item
//        itemListScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(itemNum), y: 0), animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        guard let unselectedCell = itemCategoryCollectionView.cellForItem(at: indexPath)  as? CategoryCollectionViewCell else { return }
//       animateZoomforCellremove(zoomCell: unselectedCell)
//    }
}


//extension ItemListViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//        let categoryDistanceBetweenItemsCenter = categoryCollectionViewFlowLayout.minimumLineSpacing + categoryCollectionViewFlowLayout.itemSize.width
//        let scrollViewDistanceBetweenItemsCenter = UIScreen.main.bounds.width
//        let offsetFactor = categoryDistanceBetweenItemsCenter / scrollViewDistanceBetweenItemsCenter
//
//        // test for color
//        let pageNum = Int(round(itemListScrollView.contentOffset.x / itemListScrollView.frame.size.width))
//        for iii in 0...(selectedBooling.count - 1) {
//            selectedBooling[iii] = false
//        }
//        selectedBooling[pageNum] = true
//        itemCategoryCollectionView.reloadData()
//
//
//        if scrollView === itemCategoryCollectionView {
//            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
//            itemListScrollView.bounds.origin.x = xOffset / offsetFactor
//        } else if scrollView === itemListScrollView {
//            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
//            itemCategoryCollectionView.bounds.origin.x = xOffset * offsetFactor
//        }
//    }
//
//}

