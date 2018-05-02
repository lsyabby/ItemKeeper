//
//  thirdViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import ZHDropDownMenu

class ThirdViewController: UIViewController, ZHDropDownMenuDelegate {

    @IBOutlet weak var menuView: ZHDropDownMenu!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("3 view did load")

        menuView.options = ["天气太冷了", "没睡好觉，困死了", "就是不想上班"]
        menuView.editable = true //可编辑

        menuView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        print("3 view will appear")
    }

    override func viewDidAppear(_ animated: Bool) {
        print("3 view did appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }

    // framework
    //选择完后回调
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        print("\(menu) choosed at index \(index)")
    }

    //编辑完成后回调
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        menuView.options.append(text)
        print("\(menu) input text \(text)")
    }

}
