//
//  ItemListViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit


class ItemListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var itemCategoryCollectionView: UICollectionView!
    @IBOutlet weak var itemListScrollView: UIScrollView!
    let list: [String] = ["總攬", "食品", "藥品", "美妝", "日用品", "其他"]
    var selectedBooling: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        
        itemCategoryCollectionView.showsHorizontalScrollIndicator = false
        itemListScrollView.showsHorizontalScrollIndicator = false
        
        itemCategoryCollectionView.delegate = self
        itemCategoryCollectionView.dataSource = self
        itemListScrollView.delegate = self
        
        let upnib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        itemCategoryCollectionView.register(upnib, forCellWithReuseIdentifier: "CategoryCollectionCell")
        
        // vc
        let storyboard = UIStoryboard(name: "ItemList", bundle: nil)
        guard let item0vc = storyboard.instantiateViewController(withIdentifier: "Item0") as? Item0ViewController,
            let item1vc = storyboard.instantiateViewController(withIdentifier: "Item1") as? Item1ViewController,
            let item2vc = storyboard.instantiateViewController(withIdentifier: "Item2") as? Item2ViewController,
            let item3vc = storyboard.instantiateViewController(withIdentifier: "Item3") as? Item3ViewController,
            let item4vc = storyboard.instantiateViewController(withIdentifier: "Item4") as? Item4ViewController,
            let item5vc = storyboard.instantiateViewController(withIdentifier: "Item5") as? Item5ViewController else { return }
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        itemListScrollView.contentSize = CGSize(width: CGFloat(list.count) * width, height: 0)
        let vcArray = [item0vc, item1vc, item2vc, item3vc, item4vc, item5vc]
        var idx: Int = 0
        for itemVC in vcArray {
            addChildViewController(itemVC)
            let originX: CGFloat = CGFloat(idx) * width
            itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
            itemListScrollView.addSubview(itemVC.view)
            itemVC.didMove(toParentViewController: self)
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
        itemCategoryCollectionView.reloadData()
        
        let itemNum = indexPath.item
        itemListScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(itemNum), y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let categoryDistanceBetweenItemsCenter = categoryCollectionViewFlowLayout.minimumLineSpacing + categoryCollectionViewFlowLayout.itemSize.width
        let scrollViewDistanceBetweenItemsCenter = UIScreen.main.bounds.width
        let offsetFactor = categoryDistanceBetweenItemsCenter / scrollViewDistanceBetweenItemsCenter
        
        if (scrollView == itemCategoryCollectionView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            itemListScrollView.contentOffset.x = xOffset / offsetFactor
        } else if (scrollView == itemListScrollView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            itemCategoryCollectionView.contentOffset.x = xOffset * offsetFactor
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = Int(round(itemListScrollView.contentOffset.x / itemListScrollView.frame.size.width))
        
        switch pageNum {
        case 0 :
            collectionView(itemCategoryCollectionView, didSelectItemAt: [0, 0])
            itemCategoryCollectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: true)
        case 1 :
            collectionView(itemCategoryCollectionView, didSelectItemAt: [0, 1])
            itemCategoryCollectionView.scrollToItem(at: [0, 1], at: .centeredHorizontally, animated: true)
        case 2 :
            collectionView(itemCategoryCollectionView, didSelectItemAt: [0, 2])
            itemCategoryCollectionView.scrollToItem(at: [0, 2], at: .centeredHorizontally, animated: true)
        case 3 :
            collectionView(itemCategoryCollectionView, didSelectItemAt: [0, 3])
            itemCategoryCollectionView.scrollToItem(at: [0, 3], at: .centeredHorizontally, animated: true)
        case 4 :
            collectionView(itemCategoryCollectionView, didSelectItemAt: [0, 4])
            itemCategoryCollectionView.scrollToItem(at: [0, 4], at: .centeredHorizontally, animated: true)
        case 5 :
            collectionView(itemCategoryCollectionView, didSelectItemAt: [0, 5])
            itemCategoryCollectionView.scrollToItem(at: [0, 5], at: .centeredHorizontally, animated: true)
        default:
            print("unknow location")
            return
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
    }

}
