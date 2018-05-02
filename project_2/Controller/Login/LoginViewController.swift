//
//  ViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/4/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginMailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(_ sender: Any) {
        guard let email = loginMailTextField.text, let password = passwordTextField.text else { return }
        signInFirebaseWithEmail(email: email, password: password)
    }

    @IBAction func forgetPasswordAction(_ sender: Any) {
        guard let email = loginMailTextField.text else { return }
        forgetPasswordWithEmail(email: email)
    }

    @IBAction func registerAction(_ sender: Any) {
        performSegue(withIdentifier: String(describing: RegisterViewController.self), sender: nil)
    }

    // MARK: - SIGNIN WITH EMAIL-
    func signInFirebaseWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async {
                    AppDelegate.shared.switchToLoginStoryBoard()
                }
            } else {
                print("success login")
                DispatchQueue.main.async {
                    AppDelegate.shared.switchToMainStoryBoard()
                }
            }
        }
    }

    // MARK: - FORGET PASSWORD-
    func forgetPasswordWithEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // 寄送新密碼
            }
        }
    }

}
