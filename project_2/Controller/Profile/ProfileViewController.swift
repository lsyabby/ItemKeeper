//
//  ProfileViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.isUserInteractionEnabled = true
        let touch = UITapGestureRecognizer(target: self, action: #selector(bottomAlert))
        userImageView.addGestureRecognizer(touch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutAction(_ sender: UIButton) {
        logoutEmail()
    }
    
    // logout
    func logoutEmail() {
        do {
            try Auth.auth().signOut()
            
            //            print("Did log out of facebook")
            //            let prefs = UserDefaults.standard
            //            prefs.set("", forKey: "")
            
            AppDelegate.shared.switchToLoginStoryBoard()
        } catch {
            print("There was a problem logging out")
        }
    }

}


extension ProfileViewController {
    @objc func bottomAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photoAction = UIAlertAction(title: "Photo", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
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
//        firebaseManager.updateProfilePhoto(uploadimage: image)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved", message: "Your picture has been saved to your photo library.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
