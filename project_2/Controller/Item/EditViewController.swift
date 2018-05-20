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
        nameTextField.text = list?.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
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
