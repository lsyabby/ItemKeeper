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


class FirebaseManager {
    static let shared = FirebaseManager()
    lazy var ref = Database.database().reference()
    lazy var storageRef = Storage.storage().reference()
    
    func updateProfileImage(uploadimage: UIImage?) {
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.5), let userId = Auth.auth().currentUser?.uid {
            let task = storageRef.child("profile").child("\(userId).png")
            task.putData(imageData, metadata: nil, completion: { (data, error) in
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                    return
                } else {
                    task.downloadURL(completion: { (url, error) in
                        if error == nil {
                            if let downloadUrl = url {
                                let value = downloadUrl.absoluteString
                                self.ref.child("users/\(userId)").updateChildValues(["profileImageUrl": value])
                            }
                        } else {
                            print("Error: \(error?.localizedDescription)")
                        }
                    })
                }
            })
        }
    }
    
    func addItemImage(uploadimage: UIImage?, itemdata: [String: Any]) {
        let filename = String(Int(Date().timeIntervalSince1970))
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.5), let userId = Auth.auth().currentUser?.uid {
            let task = storageRef.child("items").child("\(filename).png")
            task.putData(imageData, metadata: nil, completion: { (data, error) in
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
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
                            print("Error: \(error?.localizedDescription)")
                        }
                    })
                }
            })
        }
    }
    
    func getNewItemInfo(createdate: String) -> ItemList {
        var data: [ItemList] = []
        ref = Database.database().reference()
        if let userId = Auth.auth().currentUser?.uid {
            self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").queryEqual(toValue: createdate).observeSingleEvent(of: .value) { (snapshot) in
                guard let value = snapshot.value as? [String: Any] else { return }
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
                        data.append(info)
                    }
                }
            }
        }
        return data[0]
    }
    
}
