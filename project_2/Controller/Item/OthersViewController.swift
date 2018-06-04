//
//  OthersViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

class OthersViewController: ItemCategoryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func getData() {
        totalManager.othersManager.getCategoryData(by: ListCategory.others.rawValue) { (list) in
            self.filterByDropDownMenu(itemList: list)
        }
    }
    
}
