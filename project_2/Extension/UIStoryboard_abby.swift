//
//  UIStoryboard_abby.swift
//  project_2
//
//  Created by 李思瑩 on 2018/4/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }

    static func loginStoryboard() -> UIStoryboard { return UIStoryboard(name: "Login", bundle: nil) }

    static func itemListStoryboard() -> UIStoryboard { return UIStoryboard(name: "ItemList", bundle: nil) }
    
    static func itemDetailStoryboard() -> UIStoryboard { return UIStoryboard(name: "ItemDetail", bundle: nil) }

    static func addItemStoryboard() -> UIStoryboard { return UIStoryboard(name: "AddItem", bundle: nil) }
    
    static func trashStoryboard() -> UIStoryboard { return UIStoryboard(name: "Trash", bundle: nil) }
    
    static func alerListStoryboard() -> UIStoryboard { return UIStoryboard(name: "AlertList", bundle: nil) }
    
    static func allStoryboard() -> UIStoryboard { return UIStoryboard(name: "All", bundle: nil) }

}
