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

        setupBackgrouncView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)
    }

    func setupBackgrouncView() {

        itemBackgroundView.backgroundColor = IKConstants.ItemTableViewCellRef.backgroundViewColor

        itemBackgroundView.layer.masksToBounds = false

        itemBackgroundView.layer.shadowOffset = IKConstants.ItemTableViewCellRef.shadowOffset

        itemBackgroundView.layer.shadowOpacity = IKConstants.ItemTableViewCellRef.shadowOpacity
    }

    func setupInstockCell(item: ItemList) {

        setupCellInfo(item: item)

        itemInstockStackView.isHidden = false

        itemInstockLabel.text = "x \(item.instock)"
    }

    func setupNotInstockCell(item: ItemList) {

        setupCellInfo(item: item)

        itemInstockStackView.isHidden = true
    }

    private func setupCellInfo(item: ItemList) {

        let remainday = DateHandler.calculateRemainDay(enddate: item.endDate)

        itemNameLabel.text = item.name

        itemIdLabel.text = String(describing: item.itemId)

        itemImageView.sd_setImage(with: URL(string: item.imageURL))

        itemEnddateLabel.text = item.endDate

        itemCategoryLabel.text = "# \(item.category)"

        itemRemaindayLabel.text = "\(IKConstants.ItemTableViewCellRef.remainString) \(remainday) \(IKConstants.ItemTableViewCellRef.dayString)"
    }
}
