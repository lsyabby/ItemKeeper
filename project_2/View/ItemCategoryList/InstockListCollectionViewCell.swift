//
//  InstockListCollectionViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore
import SDWebImage
import ZHDropDownMenu

class InstockListCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, ZHDropDownMenuDelegate {

    @IBOutlet weak var filterDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var itemTableView: UITableView!
    var ref: DatabaseReference!
    var items: [ItemList] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterDropDownMenu.options = ["餅乾", "止痛藥", "乳液"]
        filterDropDownMenu.editable = true //是否编辑
        filterDropDownMenu.delegate = self
        
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        itemTableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
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
                    let name = list["name"] as? String
                    let itemId = list["id"] as? Int
                    let image = list["imageURL"] as? String
                    let createdate = list["createdate"] as? String
                    let enddate = list["enddate"] as? String
                    let alertdate = list["alertdate"] as? String
                    let category = list["category"] as? String
                    let instock = list["instock"] as? Int
                    let isInstock = list["isInstock"] as? Bool
                    let otehrs = list["others"] as? String ?? ""
                    let remainday = list["remainday"] as? Int
                    let info = ItemList(name: name!, itemId: itemId!, imageURL: image!, createdate: createdate!, enddate: enddate!, alertdate: alertdate!, category: category!, instock: instock!, isInstock: isInstock!, others: otehrs, remainday: remainday!)
                    if info.isInstock == true {
                        allItems.append(info)
                    }
                }
            }
            
            self.items = allItems
            self.itemTableView.reloadData()
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
            cell.itemEnddateLabel.text = items[indexPath.row].enddate
            cell.itemCategoryLabel.text = "# \(items[indexPath.row].category)"
            cell.itemRemaindayLabel.text = "還剩 \(items[indexPath.row].remainday) 天"
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
        //        filterDropDownMenu.options.append(text) //編輯後加入list
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }

}
