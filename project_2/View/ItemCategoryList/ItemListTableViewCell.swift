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
        
        itemBackgroundView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 0.2)
        contentView.backgroundColor = UIColor(red: 50/255.0, green: 72/255.0, blue: 97/255.0, alpha: 1.0)
        itemBackgroundView.layer.cornerRadius = 8
        itemBackgroundView.layer.masksToBounds = false
        itemBackgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(1.0).cgColor
        itemBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        itemBackgroundView.layer.shadowOpacity = 0.8
        
        itemGivePresentBtn.isHidden = true
        itemInstockImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
