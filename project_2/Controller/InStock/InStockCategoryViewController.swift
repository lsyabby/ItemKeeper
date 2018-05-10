//
//  InStockCategoryViewController.swift
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

class InStockCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ZHDropDownMenuDelegate {

    @IBOutlet weak var filterDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var instock1TableView: UITableView!
    var ref: DatabaseReference!
    var items: [ItemList] = []
    var inStockCategory: [ListCategory] = [.total, .food, .medicine, .makeup, .necessary, .others]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterDropDownMenu.options = ["最新加入優先", "提醒時間優先", "剩餘天數由少至多", "剩餘天數由多至少", "價格由高至低", "價格由低至高"]
        filterDropDownMenu.editable = false //不可编辑
        filterDropDownMenu.delegate = self
        
        instock1TableView.delegate = self
        instock1TableView.dataSource = self
        
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        instock1TableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")
        
        for category in inStockCategory {
            switch category {
            case .total: getFirebaseData()
            case .food: getFirebaseData()
            case .medicine: getFirebaseData()
            case .makeup: getFirebaseData()
            case .necessary: getFirebaseData()
            case .others: getFirebaseData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableCell", for: indexPath) as? ItemListTableViewCell {
            cell.itemInstockImageView.isHidden = true
            cell.itemNameLabel.text = items[indexPath.row].name
            cell.itemIdLabel.text = String(describing: items[indexPath.row].itemId)
            cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
            cell.itemEnddateLabel.text = items[indexPath.row].endDate
            cell.itemCategoryLabel.text = "# \(items[indexPath.row].category)"
            cell.itemRemaindayLabel.text = "還剩 \(items[indexPath.row].remainDay) 天"
            cell.itemInstockLabel.text = "x \(items[indexPath.row].instock)"
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
        controller.list = items[indexPath.row]
        show(controller, sender: nil)
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }

    func getFirebaseData() {
        ref = Database.database().reference()
        self.ref.child("instocks/mxI0h7c9GlR1eVZRqH8Sfs1LP6B2").observeSingleEvent(of: .value) { (snapshot) in
            //        self.ref.child("items/\(Auth.auth().currentUser?.uid)").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            var allItems = [ItemList]()
            for item in value {
                if let list = item.value as? [String: Any] {
                    let createdate = list["createdate"] as? String
                    let image = list["imageURL"] as? String ?? ""
                    let name = list["name"] as? String
                    let itemId = list["id"] as? Int ?? 0
                    let category = list["category"] as? String ?? "其他"
                    let enddate = list["enddate"] as? String
                    let alertdate = list["alertdate"] as? String
                    let remainday = list["remainday"] as? Int
                    let instock = list["instock"] as? Int ?? 0
                    let isInstock = list["isInstock"] as? Bool
                    let alertinstock = list["alertInstock"] as? Int
                    let price = list["price"] as? Int ?? 0
                    let otehrs = list["others"] as? String ?? ""
                    let info = ItemList(createDate: createdate!, imageURL: image, name: name!, itemId: itemId, category: category, endDate: enddate!, alertDate: alertdate!, remainDay: remainday!, instock: instock, isInstock: isInstock!, alertInstock: alertinstock!, price: price, others: otehrs)
                    if info.isInstock == true {
                        allItems.append(info)
                    }
                }
            }
            self.items = allItems
            self.instock1TableView.reloadData()
        }
    }
}
