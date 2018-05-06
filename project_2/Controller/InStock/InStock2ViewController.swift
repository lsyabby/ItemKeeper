//
//  InStock2ViewController.swift
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

class InStock2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ZHDropDownMenuDelegate {

    @IBOutlet weak var filterDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var instock2TableView: UITableView!
    var ref: DatabaseReference!
    var items: [ItemList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterDropDownMenu.options = ["餅乾", "止痛藥", "乳液"]
        filterDropDownMenu.editable = true //可编辑
        filterDropDownMenu.delegate = self
        
        instock2TableView.delegate = self
        instock2TableView.dataSource = self
        
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        instock2TableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")
        
        ref = Database.database().reference()
        self.ref.child("items/mxI0h7c9GlR1eVZRqH8Sfs1LP6B2").observeSingleEvent(of: .value) { (snapshot) in
            //        self.ref.child("items/\(Auth.auth().currentUser?.uid)").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            var allItems = [ItemList]()
            for item in value {
                print("===== item =====")
                print(item)
                if let list = item.value as? [String: Any] {
                    print("===== list =====")
                    print(list)
                    let createdate = list["createdate"] as? String
                    let image = list["imageURL"] as? String
                    let name = list["name"] as? String
                    let itemId = list["id"] as? Int
                    let category = list["category"] as? String
                    let enddate = list["enddate"] as? String
                    let alertdate = list["alertdate"] as? String
                    let remainday = list["remainday"] as? Int
                    let instock = list["instock"] as? Int
                    let isInstock = list["isInstock"] as? Bool
                    let alertinstock = list["alertinstock"] as? Int ?? 0
                    let price = list["price"] as? Int
                    let otehrs = list["others"] as? String ?? ""
                    let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, remainDay: remainday!, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
                    if info.isInstock == true {
                        allItems.append(info)
                    }
                }
            }
            self.items = allItems
            self.instock2TableView.reloadData()
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
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        filterDropDownMenu.options.append(text) //編輯後加入list
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }

}
