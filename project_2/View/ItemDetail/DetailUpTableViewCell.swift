//
//  DetailUpTableViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit


class DetailUpTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailIdLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUpCell(item: ItemList) {
        
//                cell.detailImageView.sd_setImage(with: URL(string: image))
        
        detailIdLabel.text = String(describing: item.itemId)
        
        detailNameLabel.text = item.name
        
    }

}
