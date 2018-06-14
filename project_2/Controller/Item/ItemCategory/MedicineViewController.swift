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

        manager.getMedicineItems(success: { [weak self] nonTrashItems, _  in

            self?.filterByDropDownMenu(itemList: nonTrashItems)

        }) { (error) in

            print(error)
        }
    }
}
