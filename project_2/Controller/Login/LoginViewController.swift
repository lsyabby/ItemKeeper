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
    @IBOutlet weak var mailCenterAlign: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCenterAlign: NSLayoutConstraint!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mailCenterAlign.constant -= view.bounds.width
//        passwordCenterAlign.constant -= view.bounds.width
//        loginBtn.alpha = 0.0
//
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
//            self.mailCenterAlign.constant += self.view.bounds.width
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
//            self.passwordCenterAlign.constant += self.view.bounds.width
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
//            self.loginBtn.alpha = 1
//            self.view.layoutIfNeeded()
//        }, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mailCenterAlign.constant -= view.bounds.width
        passwordCenterAlign.constant -= view.bounds.width
        loginBtn.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.mailCenterAlign.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.passwordCenterAlign.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.loginBtn.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
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
                guard let userId = Auth.auth().currentUser?.uid else { return }
                let userDefault = UserDefaults.standard
                userDefault.set(userId, forKey: "User_ID")
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
