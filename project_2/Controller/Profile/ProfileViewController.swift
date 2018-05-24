//
//  ProfileViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMailLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    var ref: DatabaseReference!
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserProfile()
        
        setupImage()
        
        setupBtn()
        
    }

    @IBAction func logoutAction(_ sender: UIButton) {
        logoutMail()
    }

}


extension ProfileViewController {
    @objc func bottomAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let photoAction = UIAlertAction(title: "相片", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "相機", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        userImageView.image = image
        firebaseManager.updateProfileImage(uploadimage: image)
        dismiss(animated: true, completion: nil)
    }
    
    private func getUserProfile() {
        ref = Database.database().reference()
        if let userId = Auth.auth().currentUser?.uid {
            self.ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let name = value?["name"] as? String,
                    let email = value?["email"] as? String,
                    let image = value?["profileImageUrl"] as? String {
                    self.userNameLabel.text = name
                    self.userMailLabel.text = email
                    self.userImageView.sd_setImage(with: URL(string: image))
                }
            })
        }
    }
    
    func logoutMail() {
        do {
            try Auth.auth().signOut()
            
            print("Did log out of LeeWoo")
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "User_ID")
            
            AppDelegate.shared.switchToLoginStoryBoard()
        } catch {
            print("There was a problem logging out")
        }
    }
    
    func setupImage() {
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
        userImageView.isUserInteractionEnabled = true
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(bottomAlert))
        userImageView.addGestureRecognizer(touch)
    }
    
    func setupBtn() {
        setBtn(btn: logoutBtn)
    }
    
    private func setBtn(btn: UIButton) {
        btn.layer.cornerRadius = btn.frame.height / 2
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let imageAC = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            imageAC.addAction(UIAlertAction(title: "OK", style: .default))
            present(imageAC, animated: true)
        } else {
            let imageAC = UIAlertController(title: "Saved", message: "Your picture has been saved to your photo library.", preferredStyle: .alert)
            imageAC.addAction(UIAlertAction(title: "OK", style: .default))
            present(imageAC, animated: true)
        }
    }
}
