//
//  RegisterViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/4/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendAction(_ sender: Any) {
        guard let name = nameTextField.text, let email = mailTextField.text, let password1 = password1TextField.text, let password2 = password2TextField.text else { return }
        if password1 == password2 {
            let password = password1
            registerFirebaseByEmail(name: name, email: email, password: password)
            DispatchQueue.main.async {
                AppDelegate.shared.switchToMainStoryBoard()
            }
        } else {
            infoLabel.text = "請重新輸入"
        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - REGISTER BY EMAIL-
    func registerFirebaseByEmail(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            print("success register")
            guard let uid = user?.uid else { return }
            let values = ["name": name as AnyObject, "email": email as AnyObject, "profileImageUrl": "" as AnyObject] as [String: AnyObject]
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            usersReference.updateChildValues(values, withCompletionBlock: { (err, _) in
                if err != nil {
                    print(err)
                    return
                }
                // send verify mail
                user?.sendEmailVerification(completion: { (error) in
                    if let error = error {
                        print(error)
                    }
                })
            })
        }
    }

}
