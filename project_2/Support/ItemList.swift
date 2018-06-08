//
//  ItemList.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/3.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

struct ItemList {
    var createDate: String
    var imageURL: String
    var name: String
    var itemId: Int
    var category: ListCategory.RawValue
    var endDate: String
    var alertDate: String
    var instock: Int
    var isInstock: Bool
    var alertInstock: Int // delete
    var price: Int
    var others: String

    static func createItemList(data: Any) -> ItemList? {

        if let list = data as? [String: Any] {
            let createdate = list["createdate"] as? String
            let image = list["imageURL"] as? String
            let name = list["name"] as? String
            let itemId = list["id"] as? Int
            let category = list["category"] as? ListCategory.RawValue
            let enddate = list["enddate"] as? String
            let alertdate = list["alertdate"] as? String
            let instock = list["instock"] as? Int
            let isInstock = list["isInstock"] as? Bool
            let alertinstock = list["alertInstock"] as? Int ?? 0
            let price = list["price"] as? Int
            let otehrs = list["others"] as? String ?? ""

            let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)

            return info
        }

        return nil
    }

    static func createRealm(info: ItemList) -> ItemInfoObject {

        let order: ItemInfoObject = ItemInfoObject()

        order.alertCreateDate = "\(info.alertDate)_\(info.createDate)"
        order.isRead = false
        order.alertNote = "有效期限到 \(info.endDate)"
        let dateformatter: DateFormatter = DateFormatter()
        dateformatter.dateFormat = "yyyy - MM - dd"
        let eString = info.alertDate
        let alertDF: Date = dateformatter.date(from: eString)!
        order.alertDateFormat = alertDF
        order.createDate = info.createDate
        order.imageURL = info.imageURL
        order.name = info.name
        order.itemId = info.itemId
        order.category = info.category
        order.endDate = info.endDate
        order.alertDate = info.alertDate
        order.instock = info.instock
        order.isInstock = info.isInstock
        order.alertInstock = info.alertInstock // delete
        order.price = info.price
        order.others = info.others

        return order
    }

}
