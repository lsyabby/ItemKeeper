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
    let taskGroup = DispatchGroup()
    
    var foodItems: [ItemList] = []
    var medicineItems: [ItemList] = []
    var makeupItems: [ItemList] = []
    var necessaryItems: [ItemList] = []
    var othersItems: [ItemList] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func getData() {
        
        getCategoryData()

    }

    private func getCategoryData() {
        
        taskGroup.enter()
        
        foodManager.getFoodItems(success: { [weak self] nonTrashItems, _  in

            self?.foodItems = nonTrashItems
            self?.taskGroup.leave()
            
        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }

        taskGroup.enter()
        
        medicineManager.getMedicineItems(success: { [weak self] nonTrashItems, _  in

            self?.medicineItems = nonTrashItems
            self?.taskGroup.leave()
            
        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }

        taskGroup.enter()
        
        makeupManager.getMakeupItems(success: { [weak self] nonTrashItems, _  in

            self?.makeupItems = nonTrashItems
            self?.taskGroup.leave()
            
        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }

        taskGroup.enter()
        
        necessaryManager.getNecessaryItems(success: { [weak self] nonTrashItems, _  in

            self?.necessaryItems = nonTrashItems
            self?.taskGroup.leave()
            
        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }

        taskGroup.enter()
        
        othersManager.getOthersItems(success: { [weak self] nonTrashItems, _  in

            self?.othersItems = nonTrashItems
            self?.taskGroup.leave()
            
        }) { [weak self] (error) in

            print(error)
            self?.taskGroup.leave()
        }
        
        taskGroup.notify(queue: .main) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.items = strongSelf.foodItems + strongSelf.medicineItems + strongSelf.makeupItems + strongSelf.necessaryItems + strongSelf.othersItems
            
            strongSelf.reloadData()
        }

    }

}
