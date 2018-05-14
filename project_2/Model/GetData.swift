//
//  GetData.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/14.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class GetData {
    static let shared = FirebaseManager()
    lazy var ref = Database.database().reference()
    lazy var storageRef = Storage.storage().reference()
    
    func getFirebaseData() {
//        print("-------\(self) getFirebaseData-------")
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
//            self.items.sort { $0.createDate > $1.createDate }
//            self.item0TableView.reloadData()
//        }
    }
    
    func byCategoryData() {
//        print("------- \(self) byCategoryData---------")
//        ref = Database.database().reference()
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        self.ref.child("items/\(userId)").queryOrdered(byChild: "category").queryEqual(toValue: self.dataType!.rawValue).observeSingleEvent(of: .value) { (snapshot) in
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
//            self.items.sort { $0.createDate > $1.createDate }
//            self.item0TableView.reloadData()
//        }
    }
    
    // for instock
    //    func getInstockFirebaseData() {
    //        ref = Database.database().reference()
    //        guard let userId = Auth.auth().currentUser?.uid else { return }
    //        //        self.ref.child("instocks/mxI0h7c9GlR1eVZRqH8Sfs1LP6B2").observeSingleEvent(of: .value) { (snapshot) in
    //        self.ref.child("instocks/\(userId)").observeSingleEvent(of: .value) { (snapshot) in
    //            guard let value = snapshot.value as? [String: Any] else { return }
    //            var allItems = [ItemList]()
    //            for item in value {
    //                if let list = item.value as? [String: Any] {
    //                    let createdate = list["createdate"] as? String
    //                    let image = list["imageURL"] as? String ?? ""
    //                    let name = list["name"] as? String
    //                    let itemId = list["id"] as? Int ?? 0
    //                    let category = list["category"] as? String ?? "其他"
    //                    let enddate = list["enddate"] as? String
    //                    let alertdate = list["alertdate"] as? String
    //                    let remainday = list["remainday"] as? Int
    //                    let instock = list["instock"] as? Int ?? 0
    //                    let isInstock = list["isInstock"] as? Bool
    //                    let alertinstock = list["alertInstock"] as? Int
    //                    let price = list["price"] as? Int ?? 0
    //                    let otehrs = list["others"] as? String ?? ""
    //                    let info = ItemList(createDate: createdate!, imageURL: image, name: name!, itemId: itemId, category: category, endDate: enddate!, alertDate: alertdate!, remainDay: remainday!, instock: instock, isInstock: isInstock!, alertInstock: alertinstock!, price: price, others: otehrs)
    //                    if info.isInstock == true {
    //                        allItems.append(info)
    //                    }
    //                }
    //            }
    //            self.items = allItems
    //            self.instock1TableView.reloadData()
    //        }
    //    }
}
