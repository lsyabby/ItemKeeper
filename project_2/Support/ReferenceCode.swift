//
//  ReferenceCode.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import FirebaseAuth

class Aaa: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.presentLoggedInScreen()
        }
    }

    // logout
    func logoutEmail() {
        do {
            try Auth.auth().signOut()
            
//            print("Did log out of facebook")
//            let prefs = UserDefaults.standard
//            prefs.set("", forKey: "")
            
            
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("There was a problem logging out")
        }
    }

    // present logged in screen
    func presentLoggedInScreen() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loggedInVC: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        self.present(loggedInVC, animated: true, completion: nil)
    }

}
