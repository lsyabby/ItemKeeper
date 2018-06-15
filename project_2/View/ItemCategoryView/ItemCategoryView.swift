//
//  ItemCategoryView.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/5.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import ZHDropDownMenu

class ItemCategoryView: UIView {

    let filterDropDownMenu = ZHDropDownMenu()

    let itemTableView = UITableView()

    convenience init() {

        self.init(frame: CGRect.zero)

        setup()
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {

        backgroundColor = UIColor.white

        setupDropDownMenu()

        setupTableView()
    }

    // MARK: - DropDownMenu -
    private func setupDropDownMenu() {

        layoutDropDownMenu()

        filterDropDownMenu.options = [IKConstants.ItemCategory.byNew, IKConstants.ItemCategory.byLess, IKConstants.ItemCategory.byMore]

        filterDropDownMenu.contentTextField.text = filterDropDownMenu.options[0]

        filterDropDownMenu.editable = false
    }

    private func layoutDropDownMenu() {

        addSubview(filterDropDownMenu)

        filterDropDownMenu.buttonImage = #imageLiteral(resourceName: "008-caret-down")

        filterDropDownMenu.translatesAutoresizingMaskIntoConstraints = false

        filterDropDownMenu.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(IKConstants.ItemCategory.ddmLeadConstant)).isActive = true

        filterDropDownMenu.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(IKConstants.ItemCategory.ddmTrailConstant)).isActive = true

        filterDropDownMenu.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(IKConstants.ItemCategory.ddmTopConstant)).isActive = true

        filterDropDownMenu.heightAnchor.constraint(equalToConstant: CGFloat(IKConstants.ItemCategory.ddmHeightConstant)).isActive = true
    }

    // MARK: - UITableView -
    private func setupTableView() {

        addSubview(itemTableView)

        itemTableView.contentInset = UIEdgeInsets(top: CGFloat(IKConstants.ItemCategory.tvTopInset), left: CGFloat(IKConstants.ItemCategory.tvLeftInset), bottom: CGFloat(IKConstants.ItemCategory.tvBottomInset), right: CGFloat(IKConstants.ItemCategory.tvRightInset))

        itemTableView.translatesAutoresizingMaskIntoConstraints = false

        itemTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(IKConstants.ItemCategory.tvLeadConstant)).isActive = true

        itemTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(IKConstants.ItemCategory.tvTrailConstant)).isActive = true

        itemTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        itemTableView.topAnchor.constraint(equalTo: filterDropDownMenu.bottomAnchor, constant: CGFloat(IKConstants.ItemCategory.tvTopConstant)).isActive = true

        itemTableView.showsVerticalScrollIndicator = false
    }
}
