//
//  AllCategoryViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/5.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class AllCategoryViewController: UIViewController {

    @IBOutlet weak var itemScrollView: UIScrollView!
    
    let categoryVCs = [TotalViewController(), FoodViewController(), MedicineViewController(), MakeupViewController(), NecessaryViewController(), OthersViewController()]
    let list: [String] = [ListCategory.total.rawValue, ListCategory.food.rawValue, ListCategory.medicine.rawValue, ListCategory.makeup.rawValue, ListCategory.necessary.rawValue, ListCategory.others.rawValue]
    
    var itemListChildViewControllers: [UIViewController] = []
    
    var categoryIndex: Int? {
        didSet {
            
            print("=================")
            
            print(categoryIndex)
            
//            test()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        
        let notificationName = Notification.Name("AddItem")
        NotificationCenter.default.addObserver(self, selector: #selector(updateNewItem(noti:)), name: notificationName, object: nil)
        
//        test()
        
        for categoryVC in categoryVCs {
            
            setupCategoryVC(categoryVC: categoryVC)
            
        }
        
    }
    
    func test() {
        let bounds = UIScreen.main.bounds
        
        let width = bounds.size.width
        
        let height = bounds.size.height
        
        guard let index = categoryIndex else { return }
        
        let itemVC = categoryVCs[index]
        
        itemVC.delegate = self
        
        addChildViewController(itemVC)
        
        let originX: CGFloat = CGFloat(index) * width
        
        itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
        
        itemScrollView.addSubview(itemVC.view)
        
        itemScrollView.setContentOffset(CGPoint(x: originX, y: 0), animated: true)
    }
    
    func setupScrollView() {
        
        itemScrollView.showsHorizontalScrollIndicator = false
        
        itemScrollView.isPagingEnabled = true
        
        itemScrollView.delegate = self
        
        contentSizeScrollView()
    }
    
    
    private func contentSizeScrollView() {
        
        let bounds = UIScreen.main.bounds
        
        let width = bounds.size.width
        
        itemScrollView.contentSize = CGSize(width: CGFloat(list.count) * width, height: 0)
        
    }
    
    func setupCategoryVC(categoryVC: ItemCategoryViewController) {
        
        let bounds = UIScreen.main.bounds
        
        let width = bounds.size.width
        
        let height = bounds.size.height
        
        let itemVC = categoryVC
        
        itemVC.delegate = self
        
        addChildViewController(itemVC)
        
        let originX: CGFloat = CGFloat(5) * width
        
        itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
        
        itemScrollView.addSubview(itemVC.view)
        
        itemVC.didMove(toParentViewController: self)
        
        itemListChildViewControllers.append(itemVC)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bounds = UIScreen.main.bounds
        
        let width = bounds.size.width
        
        let height = bounds.size.height
        
        var idx = 0
        
        for itemVC in itemListChildViewControllers {
            let originX: CGFloat = CGFloat(idx) * width
            itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
            idx += 1
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


extension AllCategoryViewController: ItemCategoryViewControllerDelegate {
    
    // MARK: - FOR RELOAD DATA AFTER DELETE ITEM -
    func updateDeleteInfo(type: ListCategory.RawValue, data: ItemList) {
        switch type {
        case ListCategory.total.rawValue:
            reloadItemCategoryVC(index: 0, data: data)
        case ListCategory.food.rawValue:
            reloadItemCategoryVC(index: 0, data: data)
            reloadItemCategoryVC(index: 1, data: data)
        case ListCategory.medicine.rawValue:
            reloadItemCategoryVC(index: 0, data: data)
            reloadItemCategoryVC(index: 2, data: data)
        case ListCategory.makeup.rawValue:
            reloadItemCategoryVC(index: 0, data: data)
            reloadItemCategoryVC(index: 3, data: data)
        case ListCategory.necessary.rawValue:
            reloadItemCategoryVC(index: 0, data: data)
            reloadItemCategoryVC(index: 4, data: data)
        case ListCategory.others.rawValue:
            reloadItemCategoryVC(index: 0, data: data)
            reloadItemCategoryVC(index: 5, data: data)
        default:
            break
        }
    }
    
    private func reloadItemCategoryVC(index: Int, data: ItemList) {
        if let itemChildVC = itemListChildViewControllers[index] as? ItemCategoryViewController {
            if let deleteIndex = itemChildVC.items.index(where: { $0.createDate == data.createDate }) {
                itemChildVC.items.remove(at: deleteIndex)
                itemChildVC.categoryView.itemTableView.reloadData()
            }
        }
    }
    
    // MARK: - FOR RELOAD DATA AFTER EDIT ITEM -
    func updateEditInfo(type: ListCategory.RawValue, data: ItemList) {
        switch type {
        case ListCategory.total.rawValue:
            reloadItemCategory(index: 0, data: data)
        case ListCategory.food.rawValue:
            reloadItemCategory(index: 0, data: data)
            reloadItemCategory(index: 1, data: data)
        case ListCategory.medicine.rawValue:
            reloadItemCategory(index: 0, data: data)
            reloadItemCategory(index: 2, data: data)
        case ListCategory.makeup.rawValue:
            reloadItemCategory(index: 0, data: data)
            reloadItemCategory(index: 3, data: data)
        case ListCategory.necessary.rawValue:
            reloadItemCategory(index: 0, data: data)
            reloadItemCategory(index: 4, data: data)
        case ListCategory.others.rawValue:
            reloadItemCategory(index: 0, data: data)
            reloadItemCategory(index: 5, data: data)
        default:
            break
        }
    }
    
    private func reloadItemCategory(index: Int, data: ItemList) {
        if let itemChildVC = itemListChildViewControllers[index] as? ItemCategoryViewController {
            if let editIndex = itemChildVC.items.index(where: { $0.createDate == data.createDate }) {
                itemChildVC.items[editIndex] = data
                itemChildVC.categoryView.itemTableView.reloadData()
            }
        }
    }
    
}


extension AllCategoryViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let listVC = UIStoryboard.itemListStoryboard().instantiateViewController(withIdentifier: String(describing: ItemListViewController.self)) as? ItemListViewController else { return }
        let pageNum = Int(round(itemScrollView.contentOffset.x / itemScrollView.frame.size.width))
        
        listVC.pageNum = pageNum
        
        guard let itemNum = categoryIndex else { return }
        itemScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(itemNum), y: 0), animated: true)
        
    }
    
}
