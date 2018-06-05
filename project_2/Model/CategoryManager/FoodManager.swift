//
//  FoodManager.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/5.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation

class FoodManager {
    
    let firebase = FirebaseManager.shared
    
    func getFoodItems(
        success: @escaping ([ItemList], [ItemList]) -> Void,
        failure: (Error) -> Void )
    {
        firebase.dictGetCategoryData(
        by: ListCategory.food.rawValue) { data in
            
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
                    
                    success(nonTrashItems, trashItems)
                    
                } else {
                    // TODO: Error handler
                }
            }
        }
    }
    
}