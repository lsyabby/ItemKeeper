//
//  AddItemDownViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/8.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import ZHDropDownMenu

class AddItemDownViewController: UIViewController, ZHDropDownMenuDelegate {

    @IBOutlet weak var categoryDropDownMenu: ZHDropDownMenu!
    var enddatePicker: UIDatePicker!
    @IBOutlet weak var enddateLabel: UILabel!
    @IBOutlet weak var alertdateLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fullScreenSize = UIScreen.main.bounds.size
        
        categoryDropDownMenu.options = ["食品", "藥品", "美妝", "日用品", "其他"]
        categoryDropDownMenu.editable = false //不可编辑
        categoryDropDownMenu.delegate = self
        
        enddatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: 100))
        enddatePicker.datePickerMode = .date
        enddatePicker.date = NSDate() as Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let fromDateTime = formatter.date(from: "2018/05/08")
        enddatePicker.minimumDate = fromDateTime
        enddatePicker.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        enddatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        enddatePicker.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.4)
        self.view.addSubview(enddatePicker)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        print("\(menu) input text \(text)")
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }
    
    @objc func datePickerChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        enddateLabel.text = formatter.string(from: enddatePicker.date)
    }

}
