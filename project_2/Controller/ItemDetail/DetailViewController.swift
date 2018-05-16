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

protocol UpdateDeleteDelegate: class {
    func getDeleteInfo(type: ListCategory.RawValue, index: Int, data: ItemList)
}


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailTableView: UITableView!
    var ref: DatabaseReference!
    var list: ItemList?
    var index: Int?
    weak var delegate: UpdateDeleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let upNib = UINib(nibName: "DetailUpTableViewCell", bundle: nil)
        detailTableView.register(upNib, forCellReuseIdentifier: "DetailUpTableCell")
        
        let downNib = UINib(nibName: "DetailDownTableViewCell", bundle: nil)
        detailTableView.register(downNib, forCellReuseIdentifier: "DetailDownTableCell")
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItem(sender:)))
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
            if let userId = Auth.auth().currentUser?.uid, let index = self.index, let itemList = self.list {
                self.ref = Database.database().reference()
                let delStorageRef = Storage.storage().reference().child("items/\(itemList.createDate).png")
                delStorageRef.delete { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("file deleted successfully")
                    }
                }
                let delDatabaseRef = self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").queryEqual(toValue: itemList.createDate).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    for info in (value?.allKeys)! {
                        print(info)
                        self.ref.child("items/\(userId)/\(info)").setValue(nil)
                        self.delegate?.getDeleteInfo(type: itemList.category, index: index, data: itemList)
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
            if let itemList = list {
                cell.downInStockLabel.text = String(describing: itemList.instock)
                cell.downAlertInStockLabel.text = String(describing: itemList.alertInstock)
                cell.downPriceLabel.text = "\(String(describing: itemList.price)) 元"
                let remainday = calculateRemainDay(enddate: itemList.endDate)
                cell.downRemainDayLabel.text = "\(remainday) 天"
            }
            cell.downOthersLabel.text = list?.others
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // MARK: - REMAINDAY CALCULATE -
    func calculateRemainDay(enddate: String) -> Int {
        let dateformatter: DateFormatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        let eString = enddate
        let endPoint: Date = dateformatter.date(from: eString)!
        let sString = dateformatter.string(from: Date())
        let startPoint: Date = dateformatter.date(from: sString)!
        let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components = gregorianCalendar.components(.day, from: startPoint, to: endPoint, options: NSCalendar.Options(rawValue: 0))
        if let remainday = components.day {
            return remainday
        } else {
            return 0
        }
    }
    
}
