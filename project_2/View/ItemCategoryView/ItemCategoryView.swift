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

        filterDropDownMenu.options = [IKConstants.ItemCategoryRef.byNew, IKConstants.ItemCategoryRef.byLess, IKConstants.ItemCategoryRef.byMore]

        filterDropDownMenu.contentTextField.text = filterDropDownMenu.options[0]

        filterDropDownMenu.editable = false
    }

    private func layoutDropDownMenu() {

        addSubview(filterDropDownMenu)

        filterDropDownMenu.buttonImage = #imageLiteral(resourceName: "008-caret-down")

        filterDropDownMenu.translatesAutoresizingMaskIntoConstraints = false

        filterDropDownMenu.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(IKConstants.ItemCategoryRef.ddmLeadConstant)).isActive = true

        filterDropDownMenu.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(IKConstants.ItemCategoryRef.ddmTrailConstant)).isActive = true

        filterDropDownMenu.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(IKConstants.ItemCategoryRef.ddmTopConstant)).isActive = true

        filterDropDownMenu.heightAnchor.constraint(equalToConstant: CGFloat(IKConstants.ItemCategoryRef.ddmHeightConstant)).isActive = true
    }

    // MARK: - UITableView -
    private func setupTableView() {

        addSubview(itemTableView)

        itemTableView.contentInset = UIEdgeInsets(top: CGFloat(IKConstants.ItemCategoryRef.tvTopInset), left: CGFloat(IKConstants.ItemCategoryRef.tvLeftInset), bottom: CGFloat(IKConstants.ItemCategoryRef.tvBottomInset), right: CGFloat(IKConstants.ItemCategoryRef.tvRightInset))

        itemTableView.translatesAutoresizingMaskIntoConstraints = false

        itemTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(IKConstants.ItemCategoryRef.tvLeadConstant)).isActive = true

        itemTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(IKConstants.ItemCategoryRef.tvTrailConstant)).isActive = true

        itemTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        itemTableView.topAnchor.constraint(equalTo: filterDropDownMenu.bottomAnchor, constant: CGFloat(IKConstants.ItemCategoryRef.tvTopConstant)).isActive = true

        itemTableView.showsVerticalScrollIndicator = false
    }
}
