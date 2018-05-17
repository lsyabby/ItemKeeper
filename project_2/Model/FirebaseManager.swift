//
//  FirebaseManager.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/17.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol FirebaseManagerDelegate: class {
    func manager(didGet items: [ItemList])
}


struct FirebaseManager {
    
    weak var delegate: FirebaseManagerDelegate?
    var ref: DatabaseReference!
    
    // MARK: - GET TOTAL DATA -
    func getTotalData(by filter: String) {
        if let userId = Auth.auth().currentUser?.uid {
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
                self.delegate?.manager(didGet: allItems)
            }
        }
    }
    
    // MARK: - GET CATEGORY DATA -
    func getCategoryData(by type: ListCategory.RawValue) {
//        ref = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        self.ref.child("items/\(userId)").queryOrdered(byChild: "category").queryEqual(toValue: type).observeSingleEvent(of: .value) { (snapshot) in
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
//            self.items = allItems
            //            if self.filterDropDownMenu.contentTextField.text == "最新加入優先" {
//            self.items.sort { $0.createDate > $1.createDate }
//            self.itemTableView.reloadData()
            //            } else if self.filterDropDownMenu.contentTextField.text == "剩餘天數由少至多" {
            //                self.items.sort { $0.remainDay < $1.remainDay }
            //                self.item0TableView.reloadData()
            //            } else if self.filterDropDownMenu.contentTextField.text == "剩餘天數由多至少" {
            //                self.items.sort { $0.remainDay > $1.remainDay }
            //                self.item0TableView.reloadData()
            //            }
        }
    }
    
}
