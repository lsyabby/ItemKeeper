//
//  ListCategory.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/7.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation

protocol StringGettable {
    func getString() -> String
}

enum ListCategory: String, StringGettable {
    
    case total = "總覽"
    case food = "食品"
    case medicine = "藥品"
    case makeup = "美妝"
    case necessary = "日用品"
    case others = "其他"
    
    func getString() -> String {
        return self.rawValue
    }
}
