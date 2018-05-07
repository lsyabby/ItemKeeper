//
//  DetailDownTableViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class DetailDownTableViewCell: UITableViewCell {

    @IBOutlet weak var downCategory: UILabel!
    @IBOutlet weak var downEndDate: UILabel!
    @IBOutlet weak var downAlertDate: UILabel!
    @IBOutlet weak var downRemainDay: UILabel!
    @IBOutlet weak var downInStock: UILabel!
    @IBOutlet weak var downAlertInStock: UILabel!
    @IBOutlet weak var downPrice: UIStackView!
    @IBOutlet weak var downOthers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
