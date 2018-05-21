//
//  TrashViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/21.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import SDWebImage

class TrashViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trashTableView: UITableView!
    var trashItem: [ItemList]?
    var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trashTableView.delegate = self
        trashTableView.dataSource = self
        
        let nib = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        trashTableView.register(nib, forCellReuseIdentifier: "ItemListTableCell")
        
        // MARK: - GET TRASH ITEM LIST -
        if let tabbarVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController {
            self.trashItem = tabbarVC.trashItem
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension TrashViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trashList = self.trashItem else { return 0 }
        return trashList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableCell", for: indexPath) as? ItemListTableViewCell, let trashList = self.trashItem {
            cell.selectionStyle = .none
            
            let remainday = firebaseManager.calculateRemainDay(enddate: trashList[indexPath.row].endDate)
            
            switch trashList[indexPath.row].isInstock {
            case true:
                cell.itemNameLabel.text = trashList[indexPath.row].name
                cell.itemIdLabel.text = String(describing: trashList[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: trashList[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = trashList[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(trashList[indexPath.row].category)"
                cell.itemRemaindayLabel.text = "還剩 \(remainday) 天"
                cell.itemInstockStackView.isHidden = false
                cell.itemInstockLabel.text = "x \(trashList[indexPath.row].instock)"
            default:
                cell.itemNameLabel.text = trashList[indexPath.row].name
                cell.itemIdLabel.text = String(describing: trashList[indexPath.row].itemId)
                cell.itemImageView.sd_setImage(with: URL(string: trashList[indexPath.row].imageURL))
                cell.itemEnddateLabel.text = trashList[indexPath.row].endDate
                cell.itemCategoryLabel.text = "# \(trashList[indexPath.row].category)"
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
}
