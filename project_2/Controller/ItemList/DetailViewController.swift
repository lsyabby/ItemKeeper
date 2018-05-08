//
//  DetailViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailTableView: UITableView!
    var list: ItemList?
    override func viewDidLoad() {
        super.viewDidLoad()

        let upNib = UINib(nibName: "DetailUpTableViewCell", bundle: nil)
        detailTableView.register(upNib, forCellReuseIdentifier: "DetailUpTableCell")
        
        let downNib = UINib(nibName: "DetailDownTableViewCell", bundle: nil)
        detailTableView.register(downNib, forCellReuseIdentifier: "DetailDownTableCell")
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
//        let editBtn = UIButton.init(type: .custom)
//        editBtn.setImage(#imageLiteral(resourceName: "002-pen-on-square-of-paper-interface-symbol"), for: .normal)
//        editBtn.addTarget(self, action: #selector(editItem(sender:)), for: .touchUpInside)
//        editBtn.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItem(sender:)))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "002-pen-on-square-of-paper-interface-symbol"), style: .plain, target: self, action: #selector(editItem(sender:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let upcell = tableView.dequeueReusableCell(withIdentifier: "DetailUpTableCell", for: indexPath) as? DetailUpTableViewCell,
            let downcell = tableView.dequeueReusableCell(withIdentifier: "DetailDownTableCell", for: indexPath) as? DetailDownTableViewCell else { return UITableViewCell() }
        if indexPath.row == 0 {
            let cell = upcell
            if let image = list?.imageURL {
                cell.detailImageView.sd_setImage(with: URL(string: image))
            }
            cell.detailNameLabel.text = list?.name
            if let itemid = list?.itemId {
                cell.detailIdLabel.text = String(describing: itemid)
            }
            return cell
        } else {
            let cell = downcell
            cell.downCategoryLabel.text = list?.category
            cell.downEndDateLabel.text = list?.endDate
            cell.downAlertDateLabel.text = list?.alertDate
            if let remainday = list?.remainDay, let instock = list?.instock, let alertinstock = list?.alertInstock, let price = list?.price {
                cell.downRemainDayLabel.text = "\(String(describing: remainday)) 天"
                cell.downInStockLabel.text = String(describing: instock)
                cell.downAlertInStockLabel.text = String(describing: alertinstock)
                cell.downPriceLabel.text = "\(String(describing: price)) 元"
            }
            cell.downOthersLabel.text = list?.others            
            return cell
        }
    }
    
    @objc func editItem(sender: UIButton) {
        print("edit!!!!!!!!!")
    }
    
}
