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
        itemBackgroundView.layer.cornerRadius = 8
        itemGivePresentBtn.isHidden = true
        itemInstockImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0))
//
//        let whiteRoundedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: 140))
//
//        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
//        whiteRoundedView.layer.masksToBounds = false
//        whiteRoundedView.layer.cornerRadius = 2.0
//        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
//        whiteRoundedView.layer.shadowOpacity = 0.2
//
//        contentView.addSubview(whiteRoundedView)
//        contentView.sendSubview(toBack: whiteRoundedView)

//    }

}
