//
//  ViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/4/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseAuth
import Lottie

class LoginViewController: UIViewController {

    @IBOutlet weak var loginMailTextField: UITextField!
    @IBOutlet weak var mailCenterAlign: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCenterAlign: NSLayoutConstraint!
    @IBOutlet weak var loginBtn: UIButton!
    let loginManager = LoginManager()

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

        animation(delay: 0.0) { [weak self] in self?.mailCenterAlign.constant += (self?.view.bounds.width)! }

        animation(delay: 0.3) { [weak self] in self?.passwordCenterAlign.constant += (self?.view.bounds.width)! }

        animation(delay: 0.5) { [weak self] in self?.loginBtn.alpha = 1 }

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
            
            loadingAnimation { blankView in
                self.loginManager.signInFirebaseWithEmail(email: email, password: password, failure: {
                    
                    blankView.removeFromSuperview()
                    self.loginBtn.backgroundColor = UIColor(red: 148/255.0, green: 17/255.0, blue: 0/255.0, alpha: 1.0)
                    
                }) {
                    
                }
            }
        }

    }

    @IBAction func forgetPasswordAction(_ sender: Any) {

        let alertController = UIAlertController(title: "", message: "請輸入電子信箱", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "電子信箱"
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "送出", style: .default) { (_) in
            if let email = alertController.textFields?.first?.text {
                self.loginManager.forgetPasswordWithEmail(email: email)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }

    @IBAction func registerAction(_ sender: Any) {

        performSegue(withIdentifier: String(describing: RegisterViewController.self), sender: nil)
    }

    @IBAction func privacyAction(_ sender: UIButton) {

        performSegue(withIdentifier: String(describing: PrivacyViewController.self), sender: nil)
    }

    private func loadingAnimation(rvView: @escaping (UIView) -> Void) {
        let animationView = LOTAnimationView(name: "simple_loader")
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height / 2 - 35)
        animationView.contentMode = .scaleAspectFill
        let blankView = UIView()
        blankView.backgroundColor = UIColor.white
        blankView.frame = UIScreen.main.bounds
        view.addSubview(blankView)
        blankView.addSubview(animationView)
        animationView.loopAnimation = false
        animationView.play { (_) in
            rvView(blankView)
        }
    }

}
