//
//  MakeupViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

class MakeupViewController: ItemCategoryViewController {
    
    let manager = MakeupManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func getData() {
        
        manager.getMakeupItems(success: { [weak self] nonTrashItems, trashItems  in
            
            self?.filterByDropDownMenu(itemList: nonTrashItems)
            
        }) { (error) in
            
            print(error)
        }
    }
    
}
