//
//  FirebaseManager.swift
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


class FirebaseManager {
    
    static let shared = FirebaseManager()
    lazy var ref = Database.database().reference()
    lazy var storageRef = Storage.storage().reference()
    
    // MARK: - DATA -
    var totalData: [ItemList] {
        return foodData + medicineData + makeupData + necessaryData + othersData
    }
    
    var foodData: [ItemList] = [] {
        didSet {
            testCategoryData(by: ListCategory.food.rawValue) { (list) in
                self.foodData = list
            }
        }
    }
    
    var medicineData: [ItemList] = [] {
        willSet {
            testCategoryData(by: ListCategory.medicine.rawValue) { (list) in
                self.medicineData = list
            }
        }
        didSet {
            testCategoryData(by: ListCategory.medicine.rawValue) { (list) in
//                self.medicineData = list
            }
        }
    }
    
    var makeupData: [ItemList] = [] {
        didSet {
            testCategoryData(by: ListCategory.makeup.rawValue) { (list) in
                self.makeupData = list
            }
        }
    }
        
    var necessaryData: [ItemList] = [] {
        didSet {
            testCategoryData(by: ListCategory.necessary.rawValue) { (list) in
                self.necessaryData = list
            }
        }
    }
    
    var othersData: [ItemList] = [] {
        didSet {
            testCategoryData(by: ListCategory.others.rawValue) { (list) in
                self.othersData = list
            }
        }
    }
    
    
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
    
    
    
    
    
    
    
    // MARK: - GET TOTAL DATA -
    func getTotalData(completion: @escaping ([ItemList], [ItemList]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            var nonTrashItems = [ItemList]()
            var trashItems = [ItemList]()
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
                    let remainday = self.calculateRemainDay(enddate: info.endDate)
                    if remainday < 0 {
                        trashItems.append(info)
                    } else {
                        nonTrashItems.append(info)
                    }
                }
            }
            completion(nonTrashItems, trashItems)
        }
    }
    
    // MARK: - GET CATEGORY DATA -
    func getCategoryData(by categoryType: ListCategory.RawValue, completion: @escaping ([ItemList]) -> Void) {
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
                    let remainday = self.calculateRemainDay(enddate: info.endDate)
                    if remainday >= 0 {
                        nonTrashItems.append(info)
                    }
                }
            }
            completion(nonTrashItems)
        }
    }
    
    // MARK: - UPDATE PROFILE IMAGE -
    func updateProfileImage(uploadimage: UIImage?) {
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.1), let userId = Auth.auth().currentUser?.uid {
            let task = storageRef.child("profile").child("\(userId).png")
            task.putData(imageData, metadata: nil, completion: { (data, error) in
                if error != nil {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    return
                } else {
                    task.downloadURL(completion: { (url, error) in
                        if error == nil {
                            if let downloadUrl = url {
                                let value = downloadUrl.absoluteString
                                self.ref.child("users/\(userId)").updateChildValues(["profileImageUrl": value])
                            }
                        } else {
                            print("Error: \(String(describing: error?.localizedDescription))")
                        }
                    })
                }
            })
        }
    }
    
    // MARK: - UPLOAD NEW ITEM IMAGE - ???
    func addItemImage(uploadimage: UIImage?, itemdata: [String: Any]) {
        let filename = String(Int(Date().timeIntervalSince1970))
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.1), let userId = Auth.auth().currentUser?.uid {
            let task = storageRef.child("items").child("\(filename).png")
            task.putData(imageData, metadata: nil, completion: { (data, error) in
                if error != nil {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    return
                } else {
                    task.downloadURL(completion: { (url, error) in
                        if error == nil {
                            if let downloadUrl = url {
                                var tempData = itemdata
                                tempData["imageURL"] = downloadUrl.absoluteString
                                self.ref.child("items/\(userId)").childByAutoId().setValue(tempData)
                            }
                        } else {
                            print("Error: \(String(describing: error?.localizedDescription))")
                        }
                    })
                }
            })
        }
    }
    
    // MARK: - DELETE DATABASE AND STORAGE DATA -
    func deleteData(index: Int, itemList: ItemList, updateDeleteInfo: @escaping () -> Void, popView: @escaping () -> Void ) {
        if let userId = Auth.auth().currentUser?.uid {
            self.ref = Database.database().reference()
            let delStorageRef = Storage.storage().reference().child("items/\(itemList.createDate).png")
            delStorageRef.delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("file deleted successfully")
                }
            }
            // delDatabaseRef
            let _ = self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").queryEqual(toValue: itemList.createDate).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                for info in (value?.allKeys)! {
                    print(info)
                    self.ref.child("items/\(userId)/\(info)").setValue(nil)
                    updateDeleteInfo()
                }
            })
            popView()
        }
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
    
}
