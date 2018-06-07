//
//  TotalManager.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class TotalManager {

//    let firebaseManager = FirebaseManager.shared
//    static let shared = TotalManager()
    lazy var ref = Database.database().reference()
    lazy var storageRef = Storage.storage().reference()

    // MARK: - DATA -
    // getCategoryData() no trashlist
    let foodManager = FirebaseManager.shared

    let medicineManager = FirebaseManager.shared

    let makeupManager = FirebaseManager.shared

    let necessaryManager = FirebaseManager.shared

    let othersManager = FirebaseManager.shared

//    var totalData: [ItemList] = [] {
//        didSet {
//            
//        }
//        return foodManager + medicineManager + makeupManager + necessaryManager + othersManager
//    }

//    var medicineData: [ItemList] = [] {
//        willSet {
//            testCategoryData(by: ListCategory.medicine.rawValue) { (list) in
//                self.medicineData = list
//            }
//        }
//        didSet {
//            testCategoryData(by: ListCategory.medicine.rawValue) { (list) in
//                //                self.medicineData = list
//            }
//        }
//    }

    // MARK: - test -
    func testCategoryData(by categoryType: ListCategory.RawValue, completion: @escaping ([ItemList]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        self.ref.child("items/\(userId)").queryOrdered(byChild: "category").queryEqual(toValue: categoryType).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            var nonTrashItems = [ItemList]()
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
                    //                    let remainday = self.calculateRemainDay(enddate: info.endDate)
                    //                    if remainday >= 0 {
                    nonTrashItems.append(info)
                    //                    }
                }
            }
            completion(nonTrashItems)

        }
    }

}
