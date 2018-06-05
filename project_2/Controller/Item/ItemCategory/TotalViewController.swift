//
//  TotalViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class TotalViewController: ItemCategoryViewController {
    
    let foodManager = FoodManager()
    let medicineManager = MedicineManager()
    let makeupManager = MakeupManager()
    let necessaryManager = NecessaryManager()
    let othersManager = OthersManager()
    var foodItems: [ItemList] = []
    var medicineItems: [ItemList] = []
    var makeupItems: [ItemList] = []
    var necessaryItems: [ItemList] = []
    var othersItems: [ItemList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func getData() {
        
//        let concurrentQueue = DispatchQueue(label: "com.total.groupqueue", qos: .default, attributes: .concurrent)
//
//        concurrentQueue.async {
//
//            let taskGroup = DispatchGroup()
//
//            taskGroup.enter()
        
        getCategoryData()
//
//        self.items =
        
            
//        }
        
    }
    
    private func getCategoryData() {
        
        foodManager.getFoodItems(success: { [weak self] nonTrashItems, trashItems  in
            
            self?.foodItems = nonTrashItems
            
        }) { (error) in
            
            print(error)
        }
        
        medicineManager.getMedicineItems(success: { [weak self] nonTrashItems, trashItems  in
            
            self?.medicineItems = nonTrashItems
            
        }) { (error) in
            
            print(error)
        }
        
        makeupManager.getMakeupItems(success: { [weak self] nonTrashItems, trashItems  in
            
            self?.makeupItems = nonTrashItems
            
        }) { (error) in
            
            print(error)
        }
        
        necessaryManager.getNecessaryItems(success: { [weak self] nonTrashItems, trashItems  in
            
            self?.necessaryItems = nonTrashItems
            
        }) { (error) in
            
            print(error)
        }
        
        othersManager.getOthersItems(success: { [weak self] nonTrashItems, trashItems  in
            
            self?.othersItems = nonTrashItems
            
        }) { (error) in
            
            print(error)
        }
        
    }
    
    
}
