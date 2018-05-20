//
//  EditViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/18.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import SDWebImage
import ZHDropDownMenu

protocol EditViewControllerDelegate {
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
    var list: ItemList?
    var editItem: ItemList?
    var delegate: EditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        guard let item = list else { return }
        self.delegate?.passFromEdit(data: ItemList(createDate: item.createDate, imageURL: item.imageURL, name: self.nameTextField.text!, itemId: Int(self.idTextField.text!)!, category: self.categoryDropDownMenu.contentTextField.text!, endDate: self.enddateTextField.text!, alertDate: self.alertdateTextField.text!, instock: Int(self.numTextField.text!)!, isInstock: self.alertInstockSwitch.isOn, alertInstock: item.alertInstock, price: Int(self.priceTextField.text!)!, others: self.othersTextView.text))
//        self.delegate?.pass(data: self.editComment.text)
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
    
}
