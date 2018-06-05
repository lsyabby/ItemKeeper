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
    
    // MARK: - DropDownMenu
    private func setupDropDownMenu() {
        
        layoutDropDownMenu()
        
        filterDropDownMenu.options = ["最新加入優先", "剩餘天數由少至多", "剩餘天數由多至少"]
        
        filterDropDownMenu.contentTextField.text = filterDropDownMenu.options[0]

        filterDropDownMenu.editable = false
    }
    
    private func layoutDropDownMenu() {
        
        addSubview(filterDropDownMenu)
        
        filterDropDownMenu.buttonImage = #imageLiteral(resourceName: "008-caret-down")
        
        filterDropDownMenu.translatesAutoresizingMaskIntoConstraints = false
        
        filterDropDownMenu.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 45).isActive = true
        
        filterDropDownMenu.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45).isActive = true
        
        filterDropDownMenu.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        filterDropDownMenu.heightAnchor.constraint(equalToConstant: 33).isActive = true
    }
    
    // MARK: - UITableView
    
    private func setupTableView() {
        
        addSubview(itemTableView)
        
        itemTableView.separatorStyle = .none
        
        itemTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        
        itemTableView.translatesAutoresizingMaskIntoConstraints = false
        
        itemTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        
        itemTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
        itemTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        itemTableView.topAnchor.constraint(equalTo: filterDropDownMenu.bottomAnchor, constant: 8).isActive = true
        
        itemTableView.showsVerticalScrollIndicator = false
    }
}
