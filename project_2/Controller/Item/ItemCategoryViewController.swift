//
//  ItemCategoryViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/6.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore
import SDWebImage
import ZHDropDownMenu

protocol ItemCategoryViewControllerDelegate: class {
    func updateDeleteInfo(type: ListCategory.RawValue, data: ItemList)
    func updateEditInfo(type: ListCategory.RawValue, data: ItemList)
}


class ItemCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ZHDropDownMenuDelegate, DetailViewControllerDelegate {

    @IBOutlet weak var filterDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var itemTableView: UITableView!
    let list: [String] = [ListCategory.food.rawValue, ListCategory.medicine.rawValue, ListCategory.makeup.rawValue, ListCategory.necessary.rawValue, ListCategory.others.rawValue]
    var ref: DatabaseReference!
    weak var delegate: ItemCategoryViewControllerDelegate?
    let firebaseManager = FirebaseManager()
    var items: [ItemList] = []
    var dataType: ListCategory? {
        didSet {
            getData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.showsVerticalScrollIndicator = false
        
        setupDropDownMenu()
        
        registerCell()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        itemTableView.addSubview(self.refreshControl())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemTableView.reloadData()
    }
    
    func setupDropDownMenu() {
        filterDropDownMenu.options = ["最新加入優先", "剩餘天數由少至多", "剩餘天數由多至少"]
        filterDropDownMenu.contentTextField.text = filterDropDownMenu.options[0]
        filterDropDownMenu.editable = false
        filterDropDownMenu.delegate = self
    }
    
    func registerCell() {
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        itemTableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")
    }
    
    // MARK: - GET FIREBASE DATA BY DIFFERENT CATEGORY -
    func getData() {
        switch self.dataType! {
        case .total:
            firebaseManager.getTotalData { [weak self] nonTrashItems, trashItems  in
                self?.filterByDropDownMenu(itemList: nonTrashItems)
                
                // MARK: - PASS TRASH ITEM LIST -
                guard let tabbarVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController else { return }
                tabbarVC.trashItem = trashItems
            }
        default:
            guard let type = self.dataType?.rawValue else { return }
            firebaseManager.getCategoryData(by: type) { [weak self] nonTrashItems in
                self?.filterByDropDownMenu(itemList: nonTrashItems)
            }
        }
    }
    
    private func filterByDropDownMenu(itemList: [ItemList]) {
        self.items = itemList
        if self.filterDropDownMenu.contentTextField.text == "最新加入優先" {
            self.items.sort { $0.createDate > $1.createDate }
            self.itemTableView.reloadData()
        } else if self.filterDropDownMenu.contentTextField.text == "剩餘天數由少至多" {
            self.items.sort { $0.endDate < $1.endDate }
            self.itemTableView.reloadData()
        } else if self.filterDropDownMenu.contentTextField.text == "剩餘天數由多至少" {
            self.items.sort { $0.endDate > $1.endDate }
            self.itemTableView.reloadData()
        }
    }
    
    // MARK: - REFRESH DATA -
    func refreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
//        refreshControl.bounds = CGRect(x: 0, y: 50, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.darkText
        itemTableView.backgroundView = refreshControl
        return refreshControl
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getData()
        itemTableView.reloadData()
        refreshControl.endRefreshing()
    }

}


extension ItemCategoryViewController {
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
            
            let remainday = firebaseManager.calculateRemainDay(enddate: items[indexPath.row].endDate)

            switch items[indexPath.row].isInstock {
            case true:
                cell.itemNameLabel.text = items[indexPath.row].name
                cell.itemIdLabel.text = String(describing: items[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = items[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(items[indexPath.row].category)"
                cell.itemRemaindayLabel.text = "還剩 \(remainday) 天"
                cell.itemInstockStackView.isHidden = false
                cell.itemInstockLabel.text = "x \(items[indexPath.row].instock)"
            default:
                cell.itemNameLabel.text = items[indexPath.row].name
                cell.itemIdLabel.text = String(describing: items[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = items[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(items[indexPath.row].category)"
                cell.itemRemaindayLabel.text = "還剩 \(remainday) 天"
                cell.itemInstockStackView.isHidden = true
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
        guard let controller = UIStoryboard.itemDetailStoryboard().instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }
        controller.delegate = self
        controller.list = items[indexPath.row]
        controller.index = indexPath.row
        show(controller, sender: nil)
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
        getData()
    }
    
    func updateDeleteInfo(type: ListCategory.RawValue, index: Int, data: ItemList) {
        items.remove(at: index)
        itemTableView.reloadData()
        self.delegate?.updateDeleteInfo(type: type, data: data)
    }
    
    func updateEditInfo(type: ListCategory.RawValue, index: Int, data: ItemList) {
        print("====== update edit info =======")
        print(type)
        items[index] = data
        itemTableView.reloadData()
        self.delegate?.updateEditInfo(type: type, data: data)
    }
    
}
