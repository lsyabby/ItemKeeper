//
//  RealmManager.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/29.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import RealmSwift

class Order: Object {
    
    @objc dynamic var createDate = ""
    @objc dynamic var name = ""
    @objc dynamic var endDate = ""
    @objc dynamic var imageUrl = ""
//    @objc dynamic var alertDate = Date()
    
}
