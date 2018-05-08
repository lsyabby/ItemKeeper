//
//  AddItemDownViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/8.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import ZHDropDownMenu

class AddItemDownViewController: UIViewController, ZHDropDownMenuDelegate {

    @IBOutlet weak var categoryDropDownMenu: ZHDropDownMenu!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryDropDownMenu.options = ["食品", "藥品", "美妝", "日用品", "其他"]
        categoryDropDownMenu.editable = false //不可编辑
        categoryDropDownMenu.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }

}
