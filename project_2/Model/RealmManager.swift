//
//  RealmManager.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/29.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import RealmSwift

//class Order: Object {
//    
//    @objc dynamic var createDate = ""
//    @objc dynamic var name = ""
//    @objc dynamic var endDate = ""
//    @objc dynamic var imageUrl = ""
////    @objc dynamic var itemInfo =
////    @objc dynamic var alertDate = Date()
//    
//}


class ItemInfoObject: Object {
    
    @objc dynamic var alertNote = ""
    @objc dynamic var createDate = ""
    @objc dynamic var imageURL = ""
    @objc dynamic var name = ""
    @objc dynamic var itemId = 0
    @objc dynamic var category = ""
    @objc dynamic var endDate = ""
    @objc dynamic var alertDate = ""
    @objc dynamic var instock = 0
    @objc dynamic var isInstock = false
    @objc dynamic var alertInstock = 0 // delete
    @objc dynamic var price = 0
    @objc dynamic var others = ""
    
}

