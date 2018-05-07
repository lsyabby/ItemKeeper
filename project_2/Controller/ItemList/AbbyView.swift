//
//  AbbyView.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/7.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class AbbyView: UIView {

    override var frame: CGRect {
        didSet {
            print("----------YA-----------")
            print("Hi")
        }
        willSet(newValue) {
            print("----------YA-----------")
            print("Hi")
        }
    }

}
