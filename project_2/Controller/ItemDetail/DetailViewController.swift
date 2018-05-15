//
//  DetailViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

protocol updateDeleteDelegate: class {
    func getDeleteInfo(type: ListCategory.RawValue, index: Int)
}


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailTableView: UITableView!
    var ref: DatabaseReference!
    var list: ItemList?
    var index: Int?
    weak var delegate: updateDeleteDelegate?
    
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

    @objc func editItem(sender: UIButton) {
        print("edit!!!!!!!!!")
    }
    
    @objc func deleteItem() {
        let alertController = UIAlertController(title: nil, message: "確定要刪除嗎？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "刪除", style: .destructive) { _ in
            if let userId = Auth.auth().currentUser?.uid, let createdate = self.list?.createDate, let category = self.list?.category, let index = self.index {
                self.ref = Database.database().reference()
                let delStorageRef = Storage.storage().reference().child("items/\(createdate).png")
                delStorageRef.delete { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("file deleted successfully")
                    }
                }
                let delDatabaseRef = self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").queryEqual(toValue: createdate).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    for info in (value?.allKeys)! {
                        print(info)
                        self.ref.child("items/\(userId)/\(info)").setValue(nil)
                        self.delegate?.getDeleteInfo(type: category, index: index)
                    }
                })
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension DetailViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let upcell = tableView.dequeueReusableCell(withIdentifier: "DetailUpTableCell", for: indexPath) as? DetailUpTableViewCell,
            let downcell = tableView.dequeueReusableCell(withIdentifier: "DetailDownTableCell", for: indexPath) as? DetailDownTableViewCell else { return UITableViewCell() }
        if indexPath.row == 0 {
            let cell = upcell
            if let image = list?.imageURL, let itemid = list?.itemId {
                cell.detailImageView.sd_setImage(with: URL(string: image))
                cell.detailIdLabel.text = String(describing: itemid)
            }
            cell.detailNameLabel.text = list?.name
            cell.deleteBtn.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
            cell.selectionStyle = .none
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
            cell.selectionStyle = .none
            return cell
        }
    }
    
}
