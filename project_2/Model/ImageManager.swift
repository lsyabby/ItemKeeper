//
//  ImageManager.swift
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


class ImageManager {
    
    static let shared = ImageManager()
    lazy var ref = Database.database().reference()
    lazy var storageRef = Storage.storage().reference()
    
    
    // MARK: - UPDATE PROFILE IMAGE -
    func updateProfileImage(uploadimage: UIImage?) {
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.1), let userId = Auth.auth().currentUser?.uid {
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
    
    // MARK: - UPLOAD NEW ITEM IMAGE - ???
    func addItemImage(uploadimage: UIImage?, itemdata: [String: Any]) {
        let filename = String(Int(Date().timeIntervalSince1970))
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.1), let userId = Auth.auth().currentUser?.uid {
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
    
}
