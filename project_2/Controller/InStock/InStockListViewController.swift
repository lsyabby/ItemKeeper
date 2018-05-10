//
//  InStockViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit


class InStockListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var listScrollView: UIScrollView!
    let list: [String] = ["總攬", "食品", "藥品", "美妝", "日用品", "其他"]
    var inStockListChildViewControllers: [UIViewController] = []
    var selectedBooling: [Bool] = []
    var inStockCategory: [ListCategory] = [.total, .food, .medicine, .makeup, .necessary, .others]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        
        categoryCollectionView.showsHorizontalScrollIndicator = false
        listScrollView.showsHorizontalScrollIndicator = false
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        listScrollView.delegate = self
        
        let upnib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollectionView.register(upnib, forCellWithReuseIdentifier: "CategoryCollectionCell")
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
//        let height = bounds.size.height
        listScrollView.contentSize = CGSize(width: CGFloat(list.count) * width, height: 0)
        for category in inStockCategory {
            switch category {
            case .total: forCategorySwitch(itemVC: "totalVC")
            case .food: forCategorySwitch(itemVC: "foodVC")
            case .medicine: forCategorySwitch(itemVC: "medicineVC")
            case .makeup: forCategorySwitch(itemVC: "makeupVC")
            case .necessary: forCategorySwitch(itemVC: "necessaryVC")
            case .others: forCategorySwitch(itemVC: "othersVC")
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        print(width)
        let height = bounds.size.height
        var idx: Int = 0
        for itemVC in inStockListChildViewControllers {
            let originX: CGFloat = CGFloat(idx) * width
            itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
            idx += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
            cell.categoryLabel.textColor = UIColor.orange
        } else {
            cell.categoryLabel.textColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for iii in 0...(selectedBooling.count - 1) {
            selectedBooling[iii] = false
        }
        selectedBooling[indexPath.item] = true
        categoryCollectionView.reloadData()
        
        let itemNum = indexPath.item
        listScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(itemNum), y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let categoryCollectionViewFlowLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let categoryDistanceBetweenItemsCenter = categoryCollectionViewFlowLayout.minimumLineSpacing + categoryCollectionViewFlowLayout.itemSize.width
        let scrollViewDistanceBetweenItemsCenter = UIScreen.main.bounds.width
        let offsetFactor = categoryDistanceBetweenItemsCenter / scrollViewDistanceBetweenItemsCenter

        if (scrollView === categoryCollectionView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            listScrollView.contentOffset.x = xOffset / offsetFactor
        } else if (scrollView === listScrollView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            categoryCollectionView.contentOffset.x = xOffset * offsetFactor
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = Int(round(listScrollView.contentOffset.x / listScrollView.frame.size.width))
        let itemNum = Int(round(categoryCollectionView.contentOffset.x / categoryCollectionView.frame.size.width))
        if pageNum != itemNum {
            collectionView(categoryCollectionView, didSelectItemAt: [0, pageNum])
            categoryCollectionView.scrollToItem(at: [0, pageNum], at: .centeredHorizontally, animated: true)
        }
        collectionView(categoryCollectionView, didSelectItemAt: [0, pageNum])
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let pageWidth: Float = Float(UIScreen.main.bounds.width)
//        let currentOffSet: Float = Float(scrollView.contentOffset.x)
//        print(currentOffSet)
//        
//        let targetOffSet: Float = Float(targetContentOffset.pointee.x)
//        print(targetOffSet)
//        
//        var newTargetOffset: Float = 0
//        
//        if (targetOffSet > currentOffSet) {
//            newTargetOffset = ceilf(currentOffSet / pageWidth) * pageWidth
//        } else {
//            newTargetOffset = floorf(currentOffSet / pageWidth) * pageWidth
//        }
//        
//        if (newTargetOffset < 0) {
//            newTargetOffset = 0
//        } else if (newTargetOffset > Float(scrollView.contentSize.width)) {
//            newTargetOffset = Float(scrollView.contentSize.width)
//        }
//        
//        targetContentOffset.pointee.x = CGFloat(currentOffSet)
//        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: 0), animated: true)
//    }
    
    @IBAction func addItemAction(_ sender: UIBarButtonItem) {
        guard let controller = UIStoryboard.addItemStoryboard().instantiateViewController(withIdentifier: String(describing: AddItemViewController.self)) as? AddItemViewController else { return }
        show(controller, sender: nil)
    }
    
    func setupListGridView() {
        let screenSize = UIScreen.main.bounds
        if let categoryCollectionViewFlowLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            categoryCollectionViewFlowLayout.itemSize = CGSize(width: screenSize.width / 2, height: categoryCollectionView.frame.height)
            categoryCollectionViewFlowLayout.minimumInteritemSpacing = 0
            categoryCollectionViewFlowLayout.minimumLineSpacing = 10
            let categoryCollectionViewSectionInset = screenSize.width / 4
            categoryCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, categoryCollectionViewSectionInset, 0, categoryCollectionViewSectionInset)
        }
    }
    
    func forCategorySwitch(itemVC: String) {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        let storyboard = UIStoryboard(name: "InStock", bundle: nil)
        guard let itemVC = storyboard.instantiateViewController(withIdentifier: "ForInStockCategory") as? InStockCategoryViewController else { return }
        addChildViewController(itemVC)
        let originX: CGFloat = CGFloat(5) * width
        itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
        listScrollView.addSubview(itemVC.view)
        itemVC.didMove(toParentViewController: self)
        inStockListChildViewControllers.append(itemVC)
    }
    
}
