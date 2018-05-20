//
//  EditViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/18.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import ZHDropDownMenu

class EditViewController: UIViewController, ZHDropDownMenuDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = list else { return }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
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
