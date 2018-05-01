//
//  FirebaseManager.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FirebaseCore


struct FirebaseUserInfo {
    var uid: String
    var email: String
    var name: String
    var userImage: URL
}


class FirebaseManager {
    static let shared = FirebaseManager()
    lazy var ref = Database.database().reference()
    lazy var storageRef = Storage.storage().reference()
    var user: FirebaseUserInfo?
    var imageReference: StorageReference {
        return storageRef.child("casual")
    }
    var profileImageReference: StorageReference {
        return storageRef.child("profile")
    }
    func getUserID() -> String? {
        if let id = AppDelegate.defaults.object(forKey: "UID") as? String {
            return id
        } else {
            return nil
        }
    }
    func updateProfilePhoto(uploadimage: UIImage?, handler: @escaping (Double)->Void = {_ in return}) {
        let filename = "\(NSUUID().uuidString)"
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 1), let uid = Auth.auth().currentUser?.uid {
            let uploadImageRef = imageReference.child(filename)
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let task = uploadImageRef.putData(imageData, metadata: metadata)
            task.observe(.success) { (snapshot) in
                let text = snapshot.metadata?.downloadURL()?.absoluteString
                self.ref.child("users/\(uid)").updateChildValues(["image": text])
            }
            task.observe(.progress) { snapshot in
                print((snapshot.progress?.fractionCompleted)! * 100) // NSProgress object
                handler(self.getPercent(snapshot.progress))
            }
        }
    }
    
    func updateChatPhoto(uploadimage: UIImage?, friendId: String?, handler: @escaping (Double)->Void = {_ in return}) {
        let filename = "\(NSUUID().uuidString)"
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 1), let uid = Auth.auth().currentUser?.uid, let friend = friendId {
            let uploadImageRef = imageReference.child(filename)
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let task = uploadImageRef.putData(imageData, metadata: metadata)
            task.observe(.success) { (snapshot) in
                let text = snapshot.metadata?.downloadURL()?.absoluteString
                // for user
                let key = self.ref.child("room").child(uid).child(friend).child("messages").childByAutoId().key
                let value = ["sender": Auth.auth().currentUser?.uid, "name": Auth.auth().currentUser?.displayName, "messageBody": text]
                let childUpdate = ["\(key)": value]
                self.ref.child("room").child(uid).child(friend).child("messages").updateChildValues(childUpdate)
                
                // for friend
                let keyF = self.ref.child("room").child(friend).child(uid).child("messages").childByAutoId().key
                let childUpdateF = ["\(keyF)": value]
                self.ref.child("room").child(friend).child(uid).child("messages").updateChildValues(childUpdateF)
            }
        }
    }
    
    func uploadFile(uploadimage: UIImage?, handler: @escaping (Double)->Void = {_ in return}) {
        let filename = "\(NSUUID().uuidString)"
        
        if let image = uploadimage, let imageData = UIImageJPEGRepresentation(image, 0), let uid = Auth.auth().currentUser?.uid {
            let uploadImageRef = imageReference.child(filename)
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let task = uploadImageRef.putData(imageData, metadata: metadata)
            task.observe(.success) { (snapshot) in
                let text = snapshot.metadata?.downloadURL()?.absoluteString
                self.ref.child("lt").child(uid).childByAutoId().setValue([
                    "url": text!,
                    "createTime": ServerValue.timestamp(),
                    "type": "image"
                    ])
            }
            task.observe(.progress) { snapshot in
                print((snapshot.progress?.fractionCompleted)! * 100) // NSProgress object
                handler(self.getPercent(snapshot.progress))
            }
            
        }
    }

    func uploadFileProfileImage(uploadURL: UIImage?) {
        let filename = "\(NSUUID().uuidString)"
        if let image = uploadURL, let imageData = UIImageJPEGRepresentation(image, 0), let uid = Auth.auth().currentUser?.uid {
            let uploadImageRef = profileImageReference.child(filename)
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let task = uploadImageRef.putData(imageData, metadata: metadata)
            task.observe(.success) { (snapshot) in
                let text = snapshot.metadata?.downloadURL()?.absoluteString
                self.ref.child("users/\(uid)").updateChildValues(["image": text])
            }
        }
    }
    func getPercent(_ progress: Progress?) -> Double {
        return (progress?.fractionCompleted)! * 100
    }
}
