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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        item0TableView.contentInset = UIEdgeInsetsMake(0, 0, 149, 0)
        item0TableView.separatorStyle = .none
        
        filterDropDownMenu.options = ["最新加入優先", "剩餘天數由少至多", "剩餘天數由多至少"] //["最新加入優先", "提醒時間優先", "剩餘天數由少至多", "剩餘天數由多至少", "價格由高至低", "價格由低至高"]
        filterDropDownMenu.contentTextField.text = filterDropDownMenu.options[0]
        filterDropDownMenu.editable = false //不可编辑
        filterDropDownMenu.delegate = self
        
        item0TableView.delegate = self
        item0TableView.dataSource = self
        
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        item0TableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        item0TableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        switch self.dataType! {
        case .total:
            getTotalData()
        default:
            getCategoryData()
        }
    }
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
                    let category = list["category"] as? String
                    let enddate = list["enddate"] as? String
                    let alertdate = list["alertdate"] as? String
//                    let remainday = list["remainday"] as? Int
                    let instock = list["instock"] as? Int
                    let isInstock = list["isInstock"] as? Bool
                    let alertinstock = list["alertInstock"] as? Int ?? 0
                    let price = list["price"] as? Int
                    let otehrs = list["others"] as? String ?? ""
                    
                    // remain day calculate
                    let dateformatter: DateFormatter = DateFormatter()
                    dateformatter.dateFormat = "MMM dd, yyyy"
                    guard let eee = enddate else { return }
                    let eString = eee
                    let endPoint: Date = dateformatter.date(from: eString)!
                    let sString = dateformatter.string(from: Date())
                    let startPoint: Date = dateformatter.date(from: sString)!
                    let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                    let components = gregorianCalendar.components(.day, from: startPoint, to: endPoint, options: NSCalendar.Options(rawValue: 0))
                    if let rrr = components.day {
                        let remainday = rrr // ???
                        let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, remainDay: remainday, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
                        allItems.append(info)
                    }
                }
            }
            self.items = allItems
            self.items.sort { $0.createDate > $1.createDate }
            self.item0TableView.reloadData()
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
                    let category = list["category"] as? String
                    let enddate = list["enddate"] as? String
                    let alertdate = list["alertdate"] as? String
//                    let remainday = list["remainday"] as? Int
                    let instock = list["instock"] as? Int
                    let isInstock = list["isInstock"] as? Bool
                    let alertinstock = list["alertInstock"] as? Int ?? 0
                    let price = list["price"] as? Int
                    let otehrs = list["others"] as? String ?? ""
                    
                    // remain day calculate
                    let dateformatter: DateFormatter = DateFormatter()
                    dateformatter.dateFormat = "MMM dd, yyyy"
                    guard let eee = enddate else { return }
                    let eString = eee
                    let endPoint: Date = dateformatter.date(from: eString)!
                    let sString = dateformatter.string(from: Date())
                    let startPoint: Date = dateformatter.date(from: sString)!
                    let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                    let components = gregorianCalendar.components(.day, from: startPoint, to: endPoint, options: NSCalendar.Options(rawValue: 0))
                    if let rrr = components.day {
                        let remainday = rrr // ???
                        let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, remainDay: remainday, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
                        allItems.append(info)
                    }
                }
            }
            self.items = allItems
            if self.filterDropDownMenu.contentTextField.text == "最新加入優先" {
                self.items.sort { $0.createDate > $1.createDate }
                self.item0TableView.reloadData()
            } else if self.filterDropDownMenu.contentTextField.text == "剩餘天數由少至多" {
                self.items.sort { $0.remainDay < $1.remainDay }
                self.item0TableView.reloadData()
            } else if self.filterDropDownMenu.contentTextField.text == "剩餘天數由多至少" {
                self.items.sort { $0.remainDay > $1.remainDay }
                self.item0TableView.reloadData()
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
            switch items[indexPath.row].isInstock {
            case true:
                cell.itemInstockImageView.isHidden = true
                cell.itemNameLabel.text = items[indexPath.row].name
                cell.itemIdLabel.text = String(describing: items[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = items[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(items[indexPath.row].category)"
                cell.itemRemaindayLabel.text = "還剩 \(items[indexPath.row].remainDay) 天"
                cell.itemInstockLabel.text = "x \(items[indexPath.row].instock)"
            default:
                cell.itemNameLabel.text = items[indexPath.row].name
                cell.itemIdLabel.text = String(describing: items[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = items[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(items[indexPath.row].category)"
                cell.itemRemaindayLabel.text = "還剩 \(items[indexPath.row].remainDay) 天"
                cell.itemInstockStackView.isHidden = true
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
}
