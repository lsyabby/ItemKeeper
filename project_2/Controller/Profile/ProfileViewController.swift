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
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMailLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    var ref: DatabaseReference!
    let firebaseManager = FirebaseManager()

    override func viewDidLoad() {

        super.viewDidLoad()

        getUserProfile()

        setupImage()

//        setupBtn()
    }

    @IBAction func logoutAction(_ sender: UIButton) {

        logoutMail()
    }
}

extension ProfileViewController {

    @objc func bottomAlert() {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        let photoAction = UIAlertAction(title: "照片", style: .default) { _ in

            let picker = UIImagePickerController()

            picker.delegate = self

            picker.sourceType = .photoLibrary

            // DOTO: CROP
            picker.allowsEditing = true

            self.present(picker, animated: true, completion: nil)
        }

        let cameraAction = UIAlertAction(title: "相機", style: .default) { _ in

            let picker = UIImagePickerController()

            picker.delegate = self

            picker.sourceType = .camera

            picker.allowsEditing = true

            self.present(picker, animated: true, completion: nil)
        }

        alertController.addAction(cancelAction)

        alertController.addAction(photoAction)

        alertController.addAction(cameraAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        let editImage = info[UIImagePickerControllerEditedImage] as? UIImage

        let originImage = info[UIImagePickerControllerOriginalImage] as? UIImage

        if picker.sourceType == .camera {

            UIImageWriteToSavedPhotosAlbum(originImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }

        userImageView.image = editImage

        firebaseManager.updateProfileImage(uploadimage: editImage)

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

                    self.userImageView.clipsToBounds = true

                    self.userImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "profile_placeholder"), completed: nil)
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

            DispatchQueue.main.async {

                AppDelegate.shared.switchToLoginStoryBoard()
            }

        } catch {

            print("There was a problem logging out")
        }
    }

    func setupImage() {

        backgroundImageView.layer.cornerRadius = backgroundImageView.frame.width / 2

        blurView.layer.cornerRadius = blurView.frame.width / 2

        userImageView.layer.cornerRadius = userImageView.frame.width / 2

        userImageView.layer.borderWidth = 5

        userImageView.layer.borderColor = UIColor.white.cgColor

        userImageView.isUserInteractionEnabled = true

        let touch = UITapGestureRecognizer(target: self, action: #selector(bottomAlert))

        userImageView.addGestureRecognizer(touch)
    }

//    func setupBtn() {
//        setBtn(btn: logoutBtn)
//    }
//
//    private func setBtn(btn: UIButton) {
//        btn.layer.cornerRadius = 5
//        btn.layer.borderWidth = 1
//        btn.layer.borderColor = UIColor(red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0).cgColor
//    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {

            let imageAC = UIAlertController(title: "儲存錯誤", message: error.localizedDescription, preferredStyle: .alert)

            imageAC.addAction(UIAlertAction(title: "確定", style: .default))

            present(imageAC, animated: true)

        } else {

            let imageAC = UIAlertController(title: "儲存照片", message: "已將相片存到相簿", preferredStyle: .alert)

            imageAC.addAction(UIAlertAction(title: "確定", style: .default))

            present(imageAC, animated: true)
        }
    }
}
