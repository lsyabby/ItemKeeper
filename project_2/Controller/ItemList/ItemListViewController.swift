//
//  ItemListViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit


class ItemListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UpdateDataDelegate, updateDeleteDelegate {

    @IBOutlet weak var itemCategoryCollectionView: UICollectionView!
    @IBOutlet weak var itemListScrollView: UIScrollView!
    let list: [String] = ["總攬", "食品", "藥品", "美妝", "日用品", "其他"]
    var itemListChildViewControllers: [UIViewController] = []
    var selectedBooling: [Bool] = []
    var listCategory: [ListCategory] = [.total, .food, .medicine, .makeup, .necessary, .others]
    let firebaseManager = FirebaseManager()
    
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
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
//        let height = bounds.size.height
        itemListScrollView.contentSize = CGSize(width: CGFloat(list.count) * width, height: 0)

        for category in listCategory {
            switch category {
            case .total:
                forCategorySwitch(itemType: ListCategory.total)
            case .food:
                forCategorySwitch(itemType: ListCategory.food)
            case .medicine:
                forCategorySwitch(itemType: ListCategory.medicine)
            case .makeup:
                forCategorySwitch(itemType: ListCategory.makeup)
            case .necessary:
                forCategorySwitch(itemType: ListCategory.necessary)
            case .others:
                forCategorySwitch(itemType: ListCategory.others)
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
        var idx = 0
        for itemVC in itemListChildViewControllers {
            let originX: CGFloat = CGFloat(idx) * width
            itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
            idx += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addItemAction(_ sender: UIBarButtonItem) {
        guard let controller = UIStoryboard.addItemStoryboard().instantiateViewController(withIdentifier: String(describing: AddItemViewController.self)) as? AddItemViewController else { return }
        controller.delegate = self
        show(controller, sender: nil)
    }
}


extension ItemListViewController {
    
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
            cell.categoryLabel.textColor = UIColor(displayP3Red: 235/255.0, green: 158/255.0, blue: 87/255.0, alpha: 1.0)
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
        
        if scrollView === itemCategoryCollectionView {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            itemListScrollView.contentOffset.x = xOffset / offsetFactor
        } else if scrollView === itemListScrollView {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            itemCategoryCollectionView.contentOffset.x = xOffset * offsetFactor
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = Int(round(itemListScrollView.contentOffset.x / itemListScrollView.frame.size.width))
        let itemNum = Int(round(itemCategoryCollectionView.contentOffset.x / itemCategoryCollectionView.frame.size.width))
        if pageNum != itemNum {
            collectionView(itemCategoryCollectionView, didSelectItemAt: [0, pageNum])
            itemCategoryCollectionView.scrollToItem(at: [0, pageNum], at: .centeredHorizontally, animated: true)
        }
        collectionView(itemCategoryCollectionView, didSelectItemAt: [0, pageNum])
    }
    
    func forCategorySwitch(itemType: ListCategory) {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        let storyboard = UIStoryboard(name: "ItemList", bundle: nil)
        guard let itemVC = storyboard.instantiateViewController(withIdentifier: String(describing: ItemCategoryViewController.self)) as? ItemCategoryViewController else { return }
        itemVC.dataType = itemType
        addChildViewController(itemVC)
        let originX: CGFloat = CGFloat(5) * width
        itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
        itemListScrollView.addSubview(itemVC.view)
        itemVC.didMove(toParentViewController: self)
        itemListChildViewControllers.append(itemVC)
    }
    
    func setupListGridView() {
        let screenSize = UIScreen.main.bounds
        if let categoryCollectionViewFlowLayout = itemCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            categoryCollectionViewFlowLayout.itemSize = CGSize(width: screenSize.width / 2, height: itemCategoryCollectionView.frame.height)
            categoryCollectionViewFlowLayout.minimumInteritemSpacing = 0
            categoryCollectionViewFlowLayout.minimumLineSpacing = 10
            let categoryCollectionViewSectionInset = screenSize.width / 4
            categoryCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, categoryCollectionViewSectionInset, 0, categoryCollectionViewSectionInset)
        }
    }
    
    func addNewItem(type: String, data: ItemList) {
        switch type {
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
    
    func getDeleteInfo(type: String, index: Int, data: ItemList) {
        switch type {
        case ListCategory.total.rawValue:
            updateDeleteItem(index: 0, data: data)
        case ListCategory.food.rawValue:
            updateDeleteItem(index: 0, data: data)
            updateDeleteItem(index: 1, data: data)
        case ListCategory.medicine.rawValue:
            updateDeleteItem(index: 0, data: data)
            updateDeleteItem(index: 2, data: data)
        case ListCategory.makeup.rawValue:
            updateDeleteItem(index: 0, data: data)
            updateDeleteItem(index: 3, data: data)
        case ListCategory.necessary.rawValue:
            updateDeleteItem(index: 0, data: data)
            updateDeleteItem(index: 4, data: data)
        case ListCategory.others.rawValue:
            updateDeleteItem(index: 0, data: data)
            updateDeleteItem(index: 5, data: data)
        default:
            break
        }

    }
    
    func updateItemList(data: ItemList, index: Int) {
        if let vc = itemListChildViewControllers[index] as? ItemCategoryViewController {
            vc.items.append(data)
            vc.items.sort { $0.createDate > $1.createDate }
            vc.item0TableView.reloadData()
        }
    }
    
    func updateDeleteItem(index: Int, data: ItemList) {
        if let vc = itemListChildViewControllers[index] as? ItemCategoryViewController {
            if let deleteIndex = vc.items.index(where: { $0.createDate == data.createDate }) {
                vc.items.remove(at: deleteIndex)
                vc.items.sort { $0.createDate > $1.createDate }
                vc.item0TableView.reloadData()
            }
        }
    }
    
}
