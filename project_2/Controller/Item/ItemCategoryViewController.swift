//
//  ItemCategoryViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/6.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import SDWebImage
import ZHDropDownMenu

protocol ItemCategoryViewControllerDelegate: class {
    func updateDeleteInfo(type: ListCategory.RawValue, data: ItemList)
    func updateEditInfo(type: ListCategory.RawValue, data: ItemList)
}

class ItemCategoryViewController: UIViewController {

    weak var delegate: ItemCategoryViewControllerDelegate?

    let categoryView = ItemCategoryView()

    var items: [ItemList] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupItemCategoryView()

        getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }

    private func setupItemCategoryView() {

        layoutItemCategoryView()

        categoryView.filterDropDownMenu.delegate = self

        categoryView.itemTableView.delegate = self

        categoryView.itemTableView.dataSource = self

        categoryView.itemTableView.separatorStyle = .none

        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)

        categoryView.itemTableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")

        categoryView.itemTableView.addSubview(self.refreshControl())

    }

    private func layoutItemCategoryView() {

        view.addSubview(categoryView)

        categoryView.translatesAutoresizingMaskIntoConstraints = false

        categoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        categoryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }

    func reloadData() {

        categoryView.itemTableView.reloadData()
    }

    // MARK: - GET FIREBASE DATA BY DIFFERENT CATEGORY -
    func getData() {
    }

    func filterByDropDownMenu(itemList: [ItemList]) {

        self.items = itemList

        if categoryView.filterDropDownMenu.contentTextField.text == "最新加入優先" {
            self.items.sort { $0.createDate > $1.createDate }
            categoryView.itemTableView.reloadData()
        } else if categoryView.filterDropDownMenu.contentTextField.text == "剩餘天數由少至多" {
            self.items.sort { $0.endDate < $1.endDate }
            categoryView.itemTableView.reloadData()
        } else if categoryView.filterDropDownMenu.contentTextField.text == "剩餘天數由多至少" {
            self.items.sort { $0.endDate > $1.endDate }
            categoryView.itemTableView.reloadData()
        }
    }

    // MARK: - REFRESH DATA -
    func refreshControl() -> UIRefreshControl {

        let refreshControl = UIRefreshControl()

        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)

        refreshControl.tintColor = UIColor.darkText

        categoryView.itemTableView.backgroundView = refreshControl

        return refreshControl
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        getData()

        reloadData()

        refreshControl.endRefreshing()
    }

}

extension ItemCategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if items.count == 0 {
            let fullScreenSize = UIScreen.main.bounds
            let imageView = UIImageView(image: #imageLiteral(resourceName: "itemKeeper_icon_v01 -01-2"))
            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            imageView.center = CGPoint(
                x: fullScreenSize.width * 0.5,
                y: fullScreenSize.height * 0.3)
            let placeholderView = UIView()
            placeholderView.addSubview(imageView)
            tableView.backgroundView = placeholderView
        } else {
            tableView.backgroundView? = refreshControl()
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableCell", for: indexPath) as? ItemListTableViewCell {
            cell.selectionStyle = .none

            switch items[indexPath.row].isInstock {
            case true:

                cell.setupInstockCell(item: items[indexPath.row])

            default:

                cell.setupNotInstockCell(item: items[indexPath.row])
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let controller = UIStoryboard
            .itemDetailStoryboard()
            .instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }

        controller.delegate = self

        controller.list = items[indexPath.row]

        controller.index = indexPath.row

        show(controller, sender: nil)
    }

}

extension ItemCategoryViewController: ZHDropDownMenuDelegate {

    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print("\(menu) input text \(text)")
    }

    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
        getData()
    }

}

extension ItemCategoryViewController: DetailViewControllerDelegate {

    func updateDeleteInfo(type: ListCategory.RawValue, index: Int, data: ItemList) {

        items.remove(at: index)

        categoryView.itemTableView.reloadData()

        self.delegate?.updateDeleteInfo(type: type, data: data)
    }

    func updateEditInfo(type: ListCategory.RawValue, index: Int, data: ItemList) {

        print("====== update edit info =======")

        print(type)

        items[index] = data

        categoryView.itemTableView.reloadData()

        self.delegate?.updateEditInfo(type: type, data: data)
    }

}
