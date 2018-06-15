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

        loginBtn.alpha = IKConstants.LoginRef.alphaBegin
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        makeAnimation()
    }

    func makeAnimation() {

        animation(delay: IKConstants.LoginRef.delay0) { [weak self] in self?.mailCenterAlign.constant += (self?.view.bounds.width)! }

        animation(delay: IKConstants.LoginRef.delay3) { [weak self] in self?.passwordCenterAlign.constant += (self?.view.bounds.width)! }

        animation(delay: IKConstants.LoginRef.delay5) { [weak self] in self?.loginBtn.alpha = IKConstants.LoginRef.alphaEnd }
    }

    private func animation(delay: Double, action: @escaping () -> Void) {

        UIView.animate(
            withDuration: IKConstants.LoginRef.delay5,
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

            AnimationHandler.loadingAnimation(animationName: IKConstants.LoginRef.animation, view: self.view) { [weak self] (blankView) in

                self?.loginManager.signInFirebaseWithEmail(email: email, password: password) { [weak self] in

                    blankView.removeFromSuperview()

                    self?.loginBtn.backgroundColor = IKConstants.LoginRef.backgroundColor
                }
            }
        }
    }

    @IBAction func forgetPasswordAction(_ sender: Any) {

        let alertController = UIAlertController(title: IKConstants.LoginRef.alertTitle, message: IKConstants.LoginRef.alertMessage, preferredStyle: .alert)

        alertController.addTextField { (textField) in

            textField.placeholder = IKConstants.LoginRef.placeholder
        }

        let cancelAction = UIAlertAction(title: IKConstants.LoginRef.cancelTitle, style: .cancel, handler: nil)

        let okAction = UIAlertAction(title: IKConstants.LoginRef.okTitle, style: .default) { (_) in

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
}
