//
//  DetailDownTableViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class DetailDownTableViewCell: UITableViewCell {

    @IBOutlet weak var downCategoryLabel: UILabel!
    @IBOutlet weak var downEndDateLabel: UILabel!
    @IBOutlet weak var downAlertDateLabel: UILabel!
    @IBOutlet weak var downRemainDayLabel: UILabel!
    @IBOutlet weak var downInStockLabel: UILabel!
    @IBOutlet weak var downAlertInStockLabel: UILabel!
    @IBOutlet weak var downPriceLabel: UILabel!
    @IBOutlet weak var downOthersLabel: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)
    }

    func setupDownCell(item: ItemList) {

        let remainday = DateHandler.calculateRemainDay(enddate: item.endDate)

        downCategoryLabel.text = item.category

        downEndDateLabel.text = item.endDate

        downAlertDateLabel.text = item.alertDate

        downInStockLabel.text = String(describing: item.instock)

        downAlertInStockLabel.text = String(describing: item.alertInstock)

        downPriceLabel.text = "\(String(describing: item.price)) \(IKConstants.ItemTableViewCellRef.priceString)"

        downRemainDayLabel.text = "\(remainday) \(IKConstants.ItemTableViewCellRef.dayString)"

        downOthersLabel.text = item.others
    }
}
