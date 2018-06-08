//
//  OthersManager.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/5.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation

class OthersManager {

    let firebase = FirebaseManager.shared

    func getOthersItems(
        success: @escaping ([ItemList], [ItemList]) -> Void,
        failure: (Error) -> Void ) {
        firebase.dictGetCategoryData(
        by: ListCategory.others.rawValue) { data in

            var nonTrashItems = [ItemList]()
            var trashItems = [ItemList]()

            for item in data {

                if let info = ItemList.createItem(data: item) {
                    
                    let remainday = DateHandler.calculateRemainDay(enddate: info.endDate)

                    if remainday < 0 {
                        trashItems.append(info)
                    } else {
                        nonTrashItems.append(info)
                    }

                } else {
                    // TODO: Error handler
                }
            }
            //success
            success(nonTrashItems, trashItems)
        }
    }

}
