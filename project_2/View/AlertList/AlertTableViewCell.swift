//
//  AlertTableViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enddateLabel: UILabel!
    @IBOutlet weak var alertdateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
