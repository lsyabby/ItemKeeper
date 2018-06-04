//
//  SearchItemViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/15.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class SearchItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var itemSearchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    
    let firebaseManager = FirebaseManager()
    var allItems: [ItemList] = []
    var searchItems: [ItemList] = []
    var scanResult: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        itemSearchBar.delegate = self
        
        registerCell()
        
        firebaseManager.getTotalData { (nonTrashItems, trashItems) in
            self.allItems = nonTrashItems + trashItems
        }
        self.searchItems = self.allItems
        
        let notificationName = Notification.Name("ScanResult")
        NotificationCenter.default.addObserver(self, selector: #selector(getScanResult(noti:)), name: notificationName, object: nil)
    }
    
    @objc func getScanResult(noti: Notification) {
        guard let data = noti.userInfo!["PASS"] as? String else { return }
        self.itemSearchBar.text = data
        matchSearchResult(text: data)
    }
    
}


extension SearchItemViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableCell", for: indexPath) as? ItemListTableViewCell {
            cell.selectionStyle = .none
            
            let remainday = firebaseManager.calculateRemainDay(enddate: searchItems[indexPath.row].endDate)
            
            switch searchItems[indexPath.row].isInstock {
            case true:
                cell.itemNameLabel.text = searchItems[indexPath.row].name
                cell.itemIdLabel.text = String(describing: searchItems[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: searchItems[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = searchItems[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(searchItems[indexPath.row].category)"
                cell.itemRemaindayLabel.text = "還剩 \(remainday) 天"
                cell.itemInstockStackView.isHidden = false
                cell.itemInstockLabel.text = "x \(searchItems[indexPath.row].instock)"
            default:
                cell.itemNameLabel.text = searchItems[indexPath.row].name
                cell.itemIdLabel.text = String(describing: searchItems[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: searchItems[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = searchItems[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(searchItems[indexPath.row].category)"
                cell.itemRemaindayLabel.text = "還剩 \(remainday) 天"
                cell.itemInstockStackView.isHidden = true
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = UIStoryboard.itemDetailStoryboard().instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }
        controller.list = searchItems[indexPath.row]
        controller.index = indexPath.row
        show(controller, sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matchSearchResult(text: searchText)
    }
    
    func registerCell() {
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        resultTableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")
    }
    
    func matchSearchResult(text: String) {
        if text == "" {
            self.searchItems = []
        } else {
            self.searchItems = []
            for item in self.allItems {
                if item.name.lowercased().hasPrefix(text.lowercased()) || String(describing: item.itemId).lowercased().hasPrefix(text.lowercased()) {
                    self.searchItems.append(item)
                }
            }
        }
        self.resultTableView.reloadData()
    }
    
}
