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
    let list: [String] = ["食品", "藥品", "美妝", "日用品", "其他"]
    var abbyChildViewControllers: [UIViewController] = []
    var selectedBooling: [Bool] = []
    
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
        
        // vc
        let storyboard = UIStoryboard(name: "InStock", bundle: nil)
        guard let item1vc = storyboard.instantiateViewController(withIdentifier: "InStock1") as? InStock1ViewController,
            let item2vc = storyboard.instantiateViewController(withIdentifier: "InStock2") as? InStock2ViewController,
            let item3vc = storyboard.instantiateViewController(withIdentifier: "InStock3") as? InStock3ViewController,
            let item4vc = storyboard.instantiateViewController(withIdentifier: "InStock4") as? InStock4ViewController,
            let item5vc = storyboard.instantiateViewController(withIdentifier: "InStock5") as? InStock5ViewController else { return }
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        print(width)
        let height = bounds.size.height
        listScrollView.contentSize = CGSize(width: CGFloat(list.count) * width, height: 0)
        let vcArray = [item1vc, item2vc, item3vc, item4vc, item5vc]
        var idx: Int = 0
        for itemVC in vcArray {
            addChildViewController(itemVC)
            listScrollView.addSubview(itemVC.view)
            itemVC.didMove(toParentViewController: self)
            idx += 1
        }
        abbyChildViewControllers = vcArray
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
        for itemVC in abbyChildViewControllers {
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
        
        if (scrollView == categoryCollectionView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            listScrollView.contentOffset.x = xOffset / offsetFactor
        } else if (scrollView == listScrollView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            categoryCollectionView.contentOffset.x = xOffset * offsetFactor
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = Int(round(listScrollView.contentOffset.x / listScrollView.frame.size.width))
        
        switch pageNum {
        case 0 :
            collectionView(categoryCollectionView, didSelectItemAt: [0, 0])
            categoryCollectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: true)
        case 1 :
            collectionView(categoryCollectionView, didSelectItemAt: [0, 1])
            categoryCollectionView.scrollToItem(at: [0, 1], at: .centeredHorizontally, animated: true)
        case 2 :
            collectionView(categoryCollectionView, didSelectItemAt: [0, 2])
            categoryCollectionView.scrollToItem(at: [0, 2], at: .centeredHorizontally, animated: true)
        case 3 :
            collectionView(categoryCollectionView, didSelectItemAt: [0, 3])
            categoryCollectionView.scrollToItem(at: [0, 3], at: .centeredHorizontally, animated: true)
        case 4 :
            collectionView(categoryCollectionView, didSelectItemAt: [0, 4])
            categoryCollectionView.scrollToItem(at: [0, 4], at: .centeredHorizontally, animated: true)
        default:
            print("unknow location")
            return
        }
    }
    
    func setupListGridView() {
        let screenSize = UIScreen.main.bounds
        if let categoryCollectionViewFlowLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            categoryCollectionViewFlowLayout.itemSize = CGSize(width: screenSize.width / 2, height: 50)
            categoryCollectionViewFlowLayout.minimumInteritemSpacing = 0
            categoryCollectionViewFlowLayout.minimumLineSpacing = 10
            let categoryCollectionViewSectionInset = screenSize.width / 4
            categoryCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, categoryCollectionViewSectionInset, 0, categoryCollectionViewSectionInset)
        }
    }
    
}
