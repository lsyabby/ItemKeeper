//
//  ViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/4/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginMailTextField: UITextField!
    @IBOutlet weak var mailCenterAlign: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCenterAlign: NSLayoutConstraint!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    let loginManager = LoginManager()

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
        
        mailCenterAlign.constant -= UIScreen.main.bounds.width
        
        passwordCenterAlign.constant -= UIScreen.main.bounds.width
        
        loginBtn.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        makeAnimation()
      
    }
    
    func makeAnimation() {
        
        animation(delay: 0.0) { self.mailCenterAlign.constant += self.view.bounds.width }
        
        animation(delay: 0.3) { self.passwordCenterAlign.constant += self.view.bounds.width }
        
        animation(delay: 0.5) { self.loginBtn.alpha = 1 }
        
    }
    
    private func animation(delay: Double, action: @escaping () -> Void) {
       
        UIView.animate(
            withDuration: 0.5,
            delay: delay,
            options: .curveEaseOut,
            animations: {
                action()
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if let email = loginMailTextField.text, let password = passwordTextField.text {
            
            loginManager.signInFirebaseWithEmail(email: email, password: password) {
                
                let bounds = self.loginBtn.bounds
                
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
                    
                    self.loginBtn.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
                    
                }
                    , completion: nil)
                
            }
            
        }
        
    }

    @IBAction func forgetPasswordAction(_ sender: Any) {
        
        if let email = loginMailTextField.text {
            
            loginManager.forgetPasswordWithEmail(email: email)
        }
        
    }

    @IBAction func registerAction(_ sender: Any) {
        
        performSegue(withIdentifier: String(describing: RegisterViewController.self), sender: nil)
    
    }

}
