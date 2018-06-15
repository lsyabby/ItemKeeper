//
//  DetailUpTableViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class DetailUpTableViewCell: UITableViewCell {

    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailIdLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!

    override func awakeFromNib() {

        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)
    }

    func setupUpCell(item: ItemList) {

        detailIdLabel.text = String(describing: item.itemId)

        detailNameLabel.text = item.name
    }
}
