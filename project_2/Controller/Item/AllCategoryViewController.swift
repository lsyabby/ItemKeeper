//
//  AllCategoryViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/5.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

protocol AllCategoryViewControllerDelegate: class {

    func categoryDidScroll(_ scrollView: UIScrollView, xOffset: CGFloat)
}

class AllCategoryViewController: UIViewController {

    @IBOutlet weak var itemScrollView: UIScrollView!
    weak var delegate: AllCategoryViewControllerDelegate?
    let categoryVCs = [TotalViewController(), FoodViewController(), MedicineViewController(), MakeupViewController(), NecessaryViewController(), OthersViewController()]
    let list: [String] = [ListCategory.total.rawValue, ListCategory.food.rawValue, ListCategory.medicine.rawValue, ListCategory.makeup.rawValue, ListCategory.necessary.rawValue, ListCategory.others.rawValue]
    var itemListChildViewControllers: [UIViewController] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        setupScrollView()

        let notificationName = Notification.Name(IKConstants.AllCategoryRef.notiName)

        NotificationCenter.default.addObserver(self, selector: #selector(updateNewItem(noti:)), name: notificationName, object: nil)

        for categoryVC in categoryVCs {

            setupCategoryVC(categoryVC: categoryVC)
        }
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

        guard let data = noti.userInfo![IKConstants.AllCategoryRef.notiPass] as? ItemList else { return }

        switch data.category {

        case ListCategory.total.rawValue:

            updateItemList(data: data, index: 0)

        case ListCategory.food.rawValue:

            updateNewData(index: 1, data: data)

        case ListCategory.medicine.rawValue:

            updateNewData(index: 2, data: data)

        case ListCategory.makeup.rawValue:

            updateNewData(index: 3, data: data)

        case ListCategory.necessary.rawValue:

            updateNewData(index: 4, data: data)

        case ListCategory.others.rawValue:

            updateNewData(index: 5, data: data)

        default:

            break
        }
    }

    private func updateNewData(index: Int, data: ItemList) {

        updateItemList(data: data, index: 0)

        updateItemList(data: data, index: index)
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

            updateDeleteData(index: 1, data: data)

        case ListCategory.medicine.rawValue:

            updateDeleteData(index: 2, data: data)

        case ListCategory.makeup.rawValue:

            updateDeleteData(index: 3, data: data)

        case ListCategory.necessary.rawValue:

            updateDeleteData(index: 4, data: data)

        case ListCategory.others.rawValue:

            updateDeleteData(index: 5, data: data)

        default:

            break
        }
    }

    private func updateDeleteData(index: Int, data: ItemList) {

        reloadItemCategoryVC(index: 0, data: data)

        reloadItemCategoryVC(index: index, data: data)
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

        updateEditData(data: data)
    }

    private func updateEditData(data: ItemList) {

        for iii in 0...5 {

            let itemVC = itemListChildViewControllers[iii] as? ItemCategoryViewController

            itemVC?.getData()

            itemVC?.categoryView.itemTableView.reloadData()
        }
    }
}

extension AllCategoryViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x

        self.delegate?.categoryDidScroll(scrollView, xOffset: xOffset)
    }
}
