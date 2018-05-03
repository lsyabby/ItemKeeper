//
//  InStockViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit


class InStockViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    let list: [String] = ["食品", "藥品", "美妝", "日用品", "其他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        
        let upnib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollectionView.register(upnib, forCellWithReuseIdentifier: "CategoryCollectionCell")
        
        let downnib = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        listCollectionView.register(downnib, forCellWithReuseIdentifier: "ListCollectionCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let ccc = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath as IndexPath) as? CategoryCollectionViewCell,
            let lll = listCollectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionCell", for: indexPath as IndexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
        
        if (collectionView == categoryCollectionView) {
            let cell = ccc
            cell.layer.cornerRadius = 20.0
            cell.layer.masksToBounds = true
            cell.categoryBtn.setTitle(list[indexPath.row], for: .normal)
            setupCategoryGridView()
            return cell
        } else {
            let cell = lll
            setupCategoryGridView()
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let categoryCollectionViewFlowLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            let listCollectionViewFlowLayout = listCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let categoryDistanceBetweenItemsCenter = categoryCollectionViewFlowLayout.minimumLineSpacing + categoryCollectionViewFlowLayout.itemSize.width
        let listDistanceBetweenItemsCenter = listCollectionViewFlowLayout.minimumLineSpacing + listCollectionViewFlowLayout.itemSize.width
        let offsetFactor = categoryDistanceBetweenItemsCenter / listDistanceBetweenItemsCenter
        
        if (scrollView == categoryCollectionView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            listCollectionView.contentOffset.x = xOffset / offsetFactor
        } else if (scrollView == listCollectionView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            categoryCollectionView.contentOffset.x = xOffset * offsetFactor
        }
    }
    
    func setupCategoryGridView() {
        let screenSize = UIScreen.main.bounds
        if let categoryCollectionViewFlowLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            categoryCollectionViewFlowLayout.itemSize = CGSize(width: screenSize.width / 2, height: 50)
            categoryCollectionViewFlowLayout.minimumInteritemSpacing = 0
            categoryCollectionViewFlowLayout.minimumLineSpacing = 10
            let categoryCollectionViewSectionInset = screenSize.width / 4
            categoryCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, categoryCollectionViewSectionInset, 0, categoryCollectionViewSectionInset)
        }
        
        if let listCollectionViewFlowLayout = listCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            listCollectionViewFlowLayout.itemSize = CGSize(width: listCollectionView.frame.width, height: listCollectionView.frame.height)
            listCollectionViewFlowLayout.minimumInteritemSpacing = 0
            listCollectionViewFlowLayout.minimumLineSpacing = 5
            listCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
}
