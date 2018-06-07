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
    let loginManager = LoginManager()

    @IBAction func sendAction(_ sender: Any) {

        if let name = nameTextField.text, let email = mailTextField.text, let password1 = password1TextField.text, let password2 = password2TextField.text {

            if password1 == password2 {

                let password = password1

                loginManager.registerFirebaseByEmail(name: name,
                                                     email: email,
                                                     password: password, presentAlert: { (alertcontroller) in
                                                        self.present(alertcontroller, animated: true, completion: nil)
                                                        })

            } else {

                //TODO: LUKE
                handlePassword()
            }
        }
    }

    @IBAction func cancelAction(_ sender: Any) {

        dismiss(animated: true, completion: nil)

    }

    func handlePassword() {

        setupPassword(pw: password1TextField)
        setupPassword(pw: password2TextField)

    }

    private func setupPassword(pw: UITextField) {

        pw.layer.cornerRadius = 5
        pw.layer.borderColor = UIColor.red.cgColor
        pw.layer.borderWidth = 1

    }

}
