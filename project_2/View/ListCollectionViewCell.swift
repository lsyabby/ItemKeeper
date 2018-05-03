//
//  ListCollectionViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/3.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import ZHDropDownMenu

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var itemTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
