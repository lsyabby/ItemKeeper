//
//  MedicineViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class MedicineViewController: ItemCategoryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func getData() {
        totalManager.medicineManager.getCategoryData(by: ListCategory.medicine.rawValue) { (list) in
            self.filterByDropDownMenu(itemList: list)
        }
    }
    
}
