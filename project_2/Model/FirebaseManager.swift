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

    // MARK: - ADD NEW ITEM -
    func addNewData(photo: UIImage, value: [String: Any], completion: @escaping (ItemList) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let filename = String(Int(Date().timeIntervalSince1970))
        let storageRef = Storage.storage().reference().child("items/\(filename).png")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        if let uploadData = UIImageJPEGRepresentation(photo, 0.1) {
            storageRef.putData(uploadData, metadata: metadata, completion: { (_, error) in
                if error != nil {
                    print("Error: \(String(describing: error?.localizedDescription))")
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        if error == nil {
                            if let downloadUrl = url {
                                var tempData = value
                                tempData["imageURL"] = downloadUrl.absoluteString
                                if let tempCreateDate = tempData["createdate"] as? String,
                                    let tempImageURL = tempData["imageURL"] as? String,
                                    let tempName = tempData["name"] as? String,
                                    let tempID = tempData["id"] as? Int,
                                    let tempCategory = tempData["category"] as? ListCategory.RawValue,
                                    let tempEnddate = tempData["enddate"] as? String,
                                    let tempAlertdate = tempData["alertdate"] as? String,
                                    let tempInstock = tempData["instock"] as? Int,
                                    let tempIsInstock = tempData["isInstock"] as? Bool,
                                    let tempAlertInstock = tempData["alertInstock"] as? Int,
                                    let tempPrice = tempData["price"] as? Int,
                                    let tempOthers = tempData["others"] as? String {
                                    let info = ItemList(createDate: tempCreateDate, imageURL: tempImageURL, name: tempName, itemId: tempID, category: tempCategory, endDate: tempEnddate, alertDate: tempAlertdate, instock: tempInstock, isInstock: tempIsInstock, alertInstock: tempAlertInstock, price: tempPrice, others: tempOthers)
                                    self.ref.child("items/\(userId)").childByAutoId().setValue(tempData)
                                    
                                    let notificationName = Notification.Name("AddItem")
                                    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": info])
                                    DispatchQueue.main.async {
                                        AppDelegate.shared.switchToMainStoryBoard()
                                    }
                                    
                                    completion(info)
                                    
                                }
                            }
                        } else {
                            print("Error: \(String(describing: error?.localizedDescription))")
                        }
                    })
                }
            })
        }
    }
    
    
    
    // MARK: - GET FIREBASE ORIGIN DATA -
    func dictGetCategoryData(
        by categoryType: ListCategory.RawValue,
        completion: @escaping ([String: Any]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        self.ref
            .child("items/\(userId)")
            .queryOrdered(byChild: "category")
            .queryEqual(toValue: categoryType)
            .observeSingleEvent(of: .value) { (snapshot) in

                guard let value = snapshot.value as? [String: Any] else { return }

                completion(value)
            }
    }

    // MARK: - UPDATE PROFILE IMAGE -
    func updateProfileImage(uploadimage: UIImage?) {
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.1), let userId = Auth.auth().currentUser?.uid {
            let task = storageRef.child("profile").child("\(userId).png")
            task.putData(imageData, metadata: nil, completion: { (_, error) in
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

    // TODO
    // MARK: - UPLOAD NEW ITEM IMAGE - ???
    func addItemImage(uploadimage: UIImage?, itemdata: [String: Any]) {
        let filename = String(Int(Date().timeIntervalSince1970))
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.1), let userId = Auth.auth().currentUser?.uid {
            let task = storageRef.child("items").child("\(filename).png")
            task.putData(imageData, metadata: nil, completion: { (_, error) in
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
            _ = self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").queryEqual(toValue: itemList.createDate).observeSingleEvent(of: .value, with: { (snapshot) in
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

}
