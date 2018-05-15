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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemGivePresentBtn.isHidden = true
        itemInstockImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
