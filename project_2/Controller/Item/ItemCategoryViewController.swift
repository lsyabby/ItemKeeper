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
}


class ItemCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ZHDropDownMenuDelegate, UpdateDeleteDelegate
//, FirebaseManagerDelegate
{

    @IBOutlet weak var filterDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var itemTableView: UITableView!
    
    var ref: DatabaseReference!
    var items: [ItemList] = []
    var dataType: ListCategory? {
        didSet {
            getData()
        }
    }
    weak var delegate: ItemCategoryViewControllerDelegate?
    var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // firebaseManager
//        firebaseManager.delegate = self
//        firebaseManager.getTotalData(by: "createdate")
        itemTableView.showsVerticalScrollIndicator = false
        
        filterDropDownMenu.options = ["最新加入優先", "剩餘天數由少至多", "剩餘天數由多至少"]
        filterDropDownMenu.contentTextField.text = filterDropDownMenu.options[0]
        filterDropDownMenu.editable = false
        filterDropDownMenu.delegate = self
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        itemTableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemTableView.reloadData()
    }
    
    // MARK: - GET FIREBASE DATA BY DIFFERENT CATEGORY -
    func getData() {
        switch self.dataType! {
        case .total:
//            items.sort { $0.createDate > $1.createDate }
//            itemTableView.reloadData()
            getTotalData()
        default:
            getCategoryData()
        }
    }
    
    
//    func getTotalData(by filter: String, action: @escaping () -> Void) {
//        ref = Database.database().reference()
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").observeSingleEvent(of: .value) { (snapshot) in
//            guard let value = snapshot.value as? [String: Any] else { return }
//            var allItems = [ItemList]()
//            for item in value {
//                if let list = item.value as? [String: Any] {
//                    let createdate = list["createdate"] as? String
//                    let image = list["imageURL"] as? String
//                    let name = list["name"] as? String
//                    let itemId = list["id"] as? Int
//                    let category = list["category"] as? ListCategory.RawValue
//                    let enddate = list["enddate"] as? String
//                    let alertdate = list["alertdate"] as? String
//                    let instock = list["instock"] as? Int
//                    let isInstock = list["isInstock"] as? Bool
//                    let alertinstock = list["alertInstock"] as? Int ?? 0
//                    let price = list["price"] as? Int
//                    let otehrs = list["others"] as? String ?? ""
//
//                    let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
//                    allItems.append(info)
//                }
//            }
//            self.items = allItems
//            action()
//            self.itemTableView.reloadData()
//        }
//    }
    
    
    
    
    func getTotalData() {
        ref = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            var allItems = [ItemList]()
            for item in value {
                if let list = item.value as? [String: Any] {
                    let createdate = list["createdate"] as? String
                    let image = list["imageURL"] as? String
                    let name = list["name"] as? String
                    let itemId = list["id"] as? Int
                    let category = list["category"] as? ListCategory.RawValue
                    let enddate = list["enddate"] as? String
                    let alertdate = list["alertdate"] as? String
                    let instock = list["instock"] as? Int
                    let isInstock = list["isInstock"] as? Bool
                    let alertinstock = list["alertInstock"] as? Int ?? 0
                    let price = list["price"] as? Int
                    let otehrs = list["others"] as? String ?? ""

                    let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
                    allItems.append(info)
                }
            }
            self.items = allItems
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
    }
    
    func getCategoryData() {
        ref = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        self.ref.child("items/\(userId)").queryOrdered(byChild: "category").queryEqual(toValue: self.dataType!.rawValue).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            var allItems = [ItemList]()
            for item in value {
                if let list = item.value as? [String: Any] {
                    let createdate = list["createdate"] as? String
                    let image = list["imageURL"] as? String
                    let name = list["name"] as? String
                    let itemId = list["id"] as? Int
                    let category = list["category"] as? ListCategory.RawValue
                    let enddate = list["enddate"] as? String
                    let alertdate = list["alertdate"] as? String
                    let instock = list["instock"] as? Int
                    let isInstock = list["isInstock"] as? Bool
                    let alertinstock = list["alertInstock"] as? Int ?? 0
                    let price = list["price"] as? Int
                    let otehrs = list["others"] as? String ?? ""
                    
                    let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
                    allItems.append(info)
                }
            }
            self.items = allItems
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
    }
}


extension ItemCategoryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableCell", for: indexPath) as? ItemListTableViewCell {
            cell.selectionStyle = .none
            
            switch items[indexPath.row].isInstock {
            case true:
                cell.itemNameLabel.text = items[indexPath.row].name
                cell.itemIdLabel.text = String(describing: items[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = items[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(items[indexPath.row].category)"
                let remainday = calculateRemainDay(enddate: items[indexPath.row].endDate)
                cell.itemRemaindayLabel.text = "還剩 \(remainday) 天"
                cell.itemInstockStackView.isHidden = false
                cell.itemInstockLabel.text = "x \(items[indexPath.row].instock)"
            default:
                cell.itemNameLabel.text = items[indexPath.row].name
                cell.itemIdLabel.text = String(describing: items[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = items[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(items[indexPath.row].category)"
                let remainday = calculateRemainDay(enddate: items[indexPath.row].endDate)
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
    
    func getDeleteInfo(type: ListCategory.RawValue, index: Int, data: ItemList) {
        items.remove(at: index)
        itemTableView.reloadData()
        self.delegate?.updateDeleteInfo(type: type, data: data)
    }
    
    // MARK: - REMAINDAY CALCULATE -
    func calculateRemainDay(enddate: String) -> Int {
        let dateformatter: DateFormatter = DateFormatter()
        dateformatter.dateFormat = "yyyy - MM - dd"
        let eString = enddate
        let endPoint: Date = dateformatter.date(from: eString)!
        let sString = dateformatter.string(from: Date())
        let startPoint: Date = dateformatter.date(from: sString)!
        let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components = gregorianCalendar.components(.day, from: startPoint, to: endPoint, options: NSCalendar.Options(rawValue: 0))
        if let remainday = components.day {
            return remainday
        } else {
            return 0
        }
    }
    
//    func manager(didGet items: [ItemList]) {
//        self.items = items
//    }
}
