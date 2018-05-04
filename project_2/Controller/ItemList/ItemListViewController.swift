//
//  ItemListViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit


class ItemListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var itemCategoryCollectionView: UICollectionView!
    @IBOutlet weak var itemListCollectionView: UICollectionView!
    let list: [String] = ["總攬", "食品", "藥品", "美妝", "日用品", "其他"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        
        let upnib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        itemCategoryCollectionView.register(upnib, forCellWithReuseIdentifier: "CategoryCollectionCell")
        
        let downnib = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        itemListCollectionView.register(downnib, forCellWithReuseIdentifier: "ListCollectionCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let ccc = itemCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath as IndexPath) as? CategoryCollectionViewCell,
            let lll = itemListCollectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionCell", for: indexPath as IndexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
        
        if (collectionView == itemCategoryCollectionView) {
            let cell = ccc
            cell.layer.cornerRadius = 20.0
            cell.layer.masksToBounds = true
            cell.categoryLabel.text = list[indexPath.row]
            setupListGridView()
            return cell
        } else {
            let cell = lll
            setupListGridView()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == itemCategoryCollectionView {
            itemListCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            let listCollectionViewFlowLayout = itemListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let categoryDistanceBetweenItemsCenter = categoryCollectionViewFlowLayout.minimumLineSpacing + categoryCollectionViewFlowLayout.itemSize.width
        let listDistanceBetweenItemsCenter = listCollectionViewFlowLayout.minimumLineSpacing + listCollectionViewFlowLayout.itemSize.width
        let offsetFactor = categoryDistanceBetweenItemsCenter / listDistanceBetweenItemsCenter
        
        if (scrollView == itemCategoryCollectionView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            itemListCollectionView.contentOffset.x = xOffset / offsetFactor
        } else if (scrollView == itemListCollectionView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            itemCategoryCollectionView.contentOffset.x = xOffset * offsetFactor
        }
    }

    func setupListGridView() {
        let screenSize = UIScreen.main.bounds
        if let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            categoryCollectionViewFlowLayout.itemSize = CGSize(width: screenSize.width / 2, height: 50)
            categoryCollectionViewFlowLayout.minimumInteritemSpacing = 0
            categoryCollectionViewFlowLayout.minimumLineSpacing = 10
            let categoryCollectionViewSectionInset = screenSize.width / 4
            categoryCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, categoryCollectionViewSectionInset, 0, categoryCollectionViewSectionInset)
        }
        
        if let listCollectionViewFlowLayout = itemListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            listCollectionViewFlowLayout.itemSize = CGSize(width: itemListCollectionView.frame.width, height: itemListCollectionView.frame.height)
            listCollectionViewFlowLayout.minimumInteritemSpacing = 0
            listCollectionViewFlowLayout.minimumLineSpacing = 5
            listCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

}
