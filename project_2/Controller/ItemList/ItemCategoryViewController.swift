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

class ItemCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ZHDropDownMenuDelegate {

    @IBOutlet weak var filterDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var item0TableView: UITableView!
    var ref: DatabaseReference!
    var items: [ItemList] = []
    
    var dataType: ListCategory? {
        didSet {
            getData()
        }
    }
    
    var noticationName: Notification.Name?
    
//    var listCategory: [ListCategory] = [.total, .food, .medicine, .makeup, .necessary, .others]
    var categoryType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterDropDownMenu.options = ["最新加入優先", "提醒時間優先", "剩餘天數由少至多", "剩餘天數由多至少", "價格由高至低", "價格由低至高"]
        filterDropDownMenu.editable = false //不可编辑
        filterDropDownMenu.delegate = self
        
        item0TableView.delegate = self
        item0TableView.dataSource = self
        
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        item0TableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")
        
        
        
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getCategoryType(noti:)), name: noticationName!, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableCell", for: indexPath) as? ItemListTableViewCell {
            cell.itemNameLabel.text = items[indexPath.row].name
            cell.itemIdLabel.text = String(describing: items[indexPath.row].itemId)
            cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
            cell.itemEnddateLabel.text = items[indexPath.row].endDate
            cell.itemCategoryLabel.text = "# \(items[indexPath.row].category)"
            cell.itemRemaindayLabel.text = "還剩 \(items[indexPath.row].remainDay) 天"
            cell.itemInstockStackView.isHidden = true
            if items[indexPath.row].isInstock == false {
                cell.itemInstockImageView.isHidden = true
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
        controller.list = items[indexPath.row]
        show(controller, sender: nil)
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }
    
    func getData() {
        switch self.dataType! {
        case .total:
            getFirebaseData()
        default:
            byCategoryData()
        }
    }
    func getFirebaseData() {
        print("-------\(self) getFirebaseData-------")
        ref = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        self.ref.child("items/\(userId)").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            var allItems = [ItemList]()
            for item in value {
                if let list = item.value as? [String: Any] {
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
                    let alertinstock = list["alertInstock"] as? Int ?? 0
                    let price = list["price"] as? Int
                    let otehrs = list["others"] as? String ?? ""
                    let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, remainDay: remainday!, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
                    allItems.append(info)
                }
            }
            self.items = allItems
            print("=========== @ @ @ ===========")
            
            print(self.items)
            print("\(self) get items total total total")
            self.item0TableView.reloadData()
        }
    }
    
    // ??? test
    func byCategoryData(category: String) {
        
        print("------- \(self) byCategoryData---------")
        ref = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        self.ref.child("items/\(userId)").queryOrdered(byChild: "category").queryEqual(toValue: self.dataType!.rawValue).observeSingleEvent(of: .value) { (snapshot) in
            
            print("\(self) did get data")
            
            guard let value = snapshot.value as? [String: Any] else { return }
            var allItems = [ItemList]()
            for item in value {
                if let list = item.value as? [String: Any] {
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
                    let alertinstock = list["alertInstock"] as? Int ?? 0
                    let price = list["price"] as? Int
                    let otehrs = list["others"] as? String ?? ""
                    let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, remainDay: remainday!, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
                    allItems.append(info)
                }
            }
            self.items = allItems
            print("============= !!! =============")
            print(self.items)
            print("\(self) get items yaaaaaaaaaaaaaa")
            self.item0TableView.reloadData()
        }
    }
    
    @objc func getCategoryType(noti: Notification) {
//        guard let pass = noti.userInfo!["CategoryType"] as? String else { return }
//        self.categoryType = pass
//        byCategoryData(category: pass)
//        getFirebaseData()
        print("======== noti =========")
        guard let pass = noti.userInfo!["CategoryType"] as? String else { return }
        
        print(pass)
        self.categoryType = pass
        switch pass {
        case ListCategory.total.rawValue:
            //            NotificationCenter.default.addObserver(self, selector: #selector(getCategoryType(noti:)), name: notificationName, object: nil)
            getFirebaseData()
        case ListCategory.food.rawValue:
            //            NotificationCenter.default.addObserver(self, selector: #selector(getCategoryType(noti:)), name: notificationName, object: nil)
            byCategoryData(category: categoryType!)
        case ListCategory.medicine.rawValue:
            //            NotificationCenter.default.addObserver(self, selector: #selector(getCategoryType(noti:)), name: notificationName, object: nil)
            byCategoryData(category: categoryType!)
        case ListCategory.makeup.rawValue:
            //            NotificationCenter.default.addObserver(self, selector: #selector(getCategoryType(noti:)), name: notificationName, object: nil)
            byCategoryData(category: categoryType!)
        case ListCategory.necessary.rawValue:
            //            NotificationCenter.default.addObserver(self, selector: #selector(getCategoryType(noti:)), name: notificationName, object: nil)
            byCategoryData(category: categoryType!)
        case ListCategory.others.rawValue:
            //            NotificationCenter.default.addObserver(self, selector: #selector(getCategoryType(noti:)), name: notificationName, object: nil)
            byCategoryData(category: categoryType!)
        default:
            break
        }
//        ref = Database.database().reference()
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        self.ref.child("items/\(userId)").queryOrdered(byChild: "category").queryEqual(toValue: pass).observeSingleEvent(of: .value) { (snapshot) in
//            guard let value = snapshot.value as? [String: Any] else { return }
//            var allItems = [ItemList]()
//            for item in value {
//                if let list = item.value as? [String: Any] {
//                    let createdate = list["createdate"] as? String
//                    let image = list["imageURL"] as? String
//                    let name = list["name"] as? String
//                    let itemId = list["id"] as? Int
//                    let category = list["category"] as? String
//                    let enddate = list["enddate"] as? String
//                    let alertdate = list["alertdate"] as? String
//                    let remainday = list["remainday"] as? Int
//                    let instock = list["instock"] as? Int
//                    let isInstock = list["isInstock"] as? Bool
//                    let alertinstock = list["alertInstock"] as? Int ?? 0
//                    let price = list["price"] as? Int
//                    let otehrs = list["others"] as? String ?? ""
//                    let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, remainDay: remainday!, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
//                    allItems.append(info)
//                }
//            }
//            self.items = allItems
////            self.items += allItems
//            print("2222222222222222222222222222222")
//            print(self.items)
//            self.item0TableView.reloadData()
//        }
    }
}
