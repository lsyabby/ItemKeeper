//
//  MedicineViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class MedicineViewController: ItemCategoryViewController {
    
    let manager = MedicineManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func getData() {

        manager.getMedicineItems(success: { [weak self] (items) in
            
            self?.items = items
            
            self?.reloadData()
        
        }) { (error) in
           
            print(error)
        }
    }
    
}
