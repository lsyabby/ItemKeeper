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
    
//    func addItemImage(uploadimage: UIImage?, handler: @escaping (Double) -> Void = { _ in return }) -> String {
//        let filename = "\(NSUUID().uuidString)"
//        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.5), let userId = Auth.auth().currentUser?.uid {
//            let uploadImageRef = storageRef.child("item").child(filename)
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/png"
//            let task = uploadImageRef.putData(imageData, metadata: metadata)
//            task.observe(.success) { (snapshot) in
//                let value = snapshot.metadata?.downloadURL()?.absoluteString
//                return value
//            }
//        }
//    }
    
    func addItemImage(uploadimage: UIImage?) -> String {
        let filename = "\(NSUUID().uuidString)"
        var url: String = ""
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0.5), let userId = Auth.auth().currentUser?.uid {
            let uploadImageRef = storageRef.child("item").child(filename)
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let task = uploadImageRef.putData(imageData, metadata: metadata)
            task.observe(.success) { (snapshot) in
                let value = snapshot.metadata?.downloadURL()?.absoluteString
                url = value!
            }
        }
        return url
    }
}
