//
//  ItemListViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore
import SDWebImage
import ZHDropDownMenu

struct ItemList {
    var name: String
    var ID: Int
    var imageURL: String
    var enddate: String
    var alertdate: String
    var category: String
    var instock: Int
    var isInstock: Bool
    var others: String
}

class ItemListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ZHDropDownMenuDelegate {
    
    @IBOutlet weak var filterDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var itemListCollectionView: UICollectionView!
    var ref: DatabaseReference!
    var items: [ItemList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        
        filterDropDownMenu.options = ["最新加入優先", "剩餘時間由少至多"]
        filterDropDownMenu.editable = false //是否编辑
        filterDropDownMenu.delegate = self
        
        itemListCollectionView.delegate = self
        itemListCollectionView.dataSource = self
        
        let nib = UINib(nibName: "ItemListCollectionViewCell", bundle: nil)
        itemListCollectionView.register(nib, forCellWithReuseIdentifier: "ItemListCell")
        
        ref = Database.database().reference()
        self.ref.child("items/mxI0h7c9GlR1eVZRqH8Sfs1LP6B2").observeSingleEvent(of: .value) { (snapshot) in
//        self.ref.child("items/\(Auth.auth().currentUser?.uid)").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            var allItems = [ItemList]()
            for item in value {
                print("===== item =====")
                print(item)
                if let list = item.value as? [String: Any] {
                    print("===== list =====")
                    print(list)
                    let name = list["name"] as? String
                    let id = list["id"] as? Int
                    let image = list["imageURL"] as? String
                    let enddate = list["enddate"] as? String
                    let alertdate = list["alertdate"] as? String
                    let category = list["category"] as? String
                    let instock = list["instock"] as? Int
                    let isInstock = list["isInstock"] as? Bool
                    let otehrs = list["others"] as? String ?? ""
                    let info = ItemList(name: name!, ID: id!, imageURL: image!, enddate: enddate!, alertdate: alertdate!, category: category!, instock: instock!, isInstock: isInstock!, others: otehrs)
                    allItems.append(info)
                }
            }
            self.items = allItems
            self.itemListCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemListCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell", for: indexPath) as! ItemListCollectionViewCell
        cell.itemNameLabel.text = items[indexPath.row].name
        cell.itemIdLabel.text = String(describing: items[indexPath.row].ID)
        cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
        cell.itemEndDateLabel.text = items[indexPath.row].enddate
        cell.itemCategoryLabel.text = items[indexPath.row].category
        setupListGridView()
        return cell
    }
    
    // 选择完后回调
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }
    
    // 编辑完成后回调
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
//        filterDropDownMenu.options.append(text) //編輯後加入
        print("\(menu) input text \(text)")
    }
    
    func setupListGridView() {
        let flow = itemListCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        flow.itemSize = CGSize(width: CGFloat(UIScreen.main.bounds.width / 1), height: 150)
        flow.minimumInteritemSpacing = 5
        flow.minimumLineSpacing = 5
        itemListCollectionView.setCollectionViewLayout(flow, animated: true)
    }

}
