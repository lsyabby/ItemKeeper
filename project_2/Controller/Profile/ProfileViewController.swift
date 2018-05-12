//
//  ProfileViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
