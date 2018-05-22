//
//  EditViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/18.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import ZHDropDownMenu

protocol EditViewControllerDelegate: class {
    func passFromEdit(data: ItemList)
}

class EditViewController: UIViewController, ZHDropDownMenuDelegate {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var categoryDropDownMenu: ZHDropDownMenu!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var enddateTextField: UITextField!
    @IBOutlet weak var alertdateTextField: UITextField!
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var alertInstockSwitch: UISwitch!
    @IBOutlet weak var othersTextView: UITextView!
    weak var delegate: EditViewControllerDelegate?
    var ref: DatabaseReference!
    var list: ItemList?
    var editItem: ItemList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupOthersTextView()
        
        setupDropDownMenu()
        
        setupEditItems()
        
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        ref = Database.database().reference()
        guard let item = list else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let updatedate = String(Int(Date().timeIntervalSince1970))
        let name = nameTextField.text ?? item.name
        let id = Int(idTextField.text!) ?? item.itemId
        let category = categoryDropDownMenu.contentTextField.text ?? item.createDate
        let enddate = enddateTextField.text ?? item.endDate
        let alertdate = alertdateTextField.text ?? item.alertDate
        let instock = Int(numTextField.text!) ?? item.instock
        let isinstock = alertInstockSwitch.isOn
        let alertinstock = item.alertInstock
        let price = Int(priceTextField.text!) ?? item.price
        let others = othersTextView.text ?? item.others
        
        // "imageURL": "",
        let editValue = ["updatedate": updatedate, "name": name, "id": id, "category": category, "enddate": enddate, "alertdate": alertdate, "instock": instock, "isInstock": isinstock, "alertInstock": alertinstock, "price": price, "others": others] as [String : Any]
        
        self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").queryEqual(toValue: item.createDate).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for info in (value?.allKeys)! {
                print("======= edit item !!!! @@@@ ======")
                print(info)
                self.ref.child("items/\(userId)/\(info)").updateChildValues(editValue)
            }
        }
        
        self.delegate?.passFromEdit(data: ItemList(createDate: item.createDate, imageURL: item.imageURL, name: self.nameTextField.text!, itemId: Int(self.idTextField.text!)!, category: self.categoryDropDownMenu.contentTextField.text!, endDate: self.enddateTextField.text!, alertDate: self.alertdateTextField.text!, instock: Int(self.numTextField.text!)!, isInstock: self.alertInstockSwitch.isOn, alertInstock: item.alertInstock, price: Int(self.priceTextField.text!)!, others: self.othersTextView.text))
        dismiss(animated: true, completion: nil)
    }
}


extension EditViewController {
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print(text)
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print(index)
    }
    
    func setupEditItems() {
        guard let item = list else { return }
        itemImageView.sd_setImage(with: URL(string: item.imageURL))
        nameTextField.text = item.name
        idTextField.text = String(describing: item.itemId)
        categoryDropDownMenu.contentTextField.text = item.category
        priceTextField.text = String(describing: item.price)
        enddateTextField.text = item.endDate
        alertdateTextField.text = item.alertDate
        numTextField.text = String(describing: item.instock)
        alertInstockSwitch.isOn = item.isInstock
        othersTextView.text = item.others
    }
    
    func setupOthersTextView() {
        othersTextView.layer.cornerRadius = 5
        othersTextView.layer.borderWidth = 1
        othersTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupDropDownMenu() {
        categoryDropDownMenu.options = [ListCategory.total.rawValue, ListCategory.food.rawValue, ListCategory.medicine.rawValue, ListCategory.makeup.rawValue, ListCategory.necessary.rawValue, ListCategory.others.rawValue]
        categoryDropDownMenu.contentTextField.text = list?.category
        categoryDropDownMenu.editable = false
        categoryDropDownMenu.delegate = self
    }
    
}
