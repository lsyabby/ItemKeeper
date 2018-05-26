//
//  ItemListTableViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemIdLabel: UILabel!
    @IBOutlet weak var itemEnddateLabel: UILabel!
    @IBOutlet weak var itemCategoryLabel: UILabel!
    @IBOutlet weak var itemGivePresentBtn: UIButton!
    @IBOutlet weak var itemRemaindayLabel: UILabel!
    @IBOutlet weak var itemInstockImageView: UIImageView!
    @IBOutlet weak var itemInstockLabel: UILabel!
    @IBOutlet weak var itemInstockStackView: UIStackView!
    @IBOutlet weak var itemBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor(red: 243/255.0, green: 255/255.0, blue: 250/255.0, alpha: 1.0)
        itemBackgroundView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8)
        itemBackgroundView.layer.masksToBounds = false
        itemBackgroundView.layer.shadowOffset = CGSize(width: -1, height: 1)
        itemBackgroundView.layer.shadowOpacity = 0.2
        
        itemGivePresentBtn.isHidden = true
        itemInstockImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
