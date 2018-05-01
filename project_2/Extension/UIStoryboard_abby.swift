//
//  UIStoryboard_abby.swift
//  project_2
//
//  Created by 李思瑩 on 2018/4/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func loginStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
    static func registerStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: "Register", bundle: nil)
    }
    
    static func mainStoryboard() -> UIStoryboard {

        return UIStoryboard(name: "Main", bundle: nil)
    }
//
//    static func profileStoryboard() -> UIStoryboard {
//
//        return UIStoryboard(name: "Profile", bundle: nil)
//    }
}
