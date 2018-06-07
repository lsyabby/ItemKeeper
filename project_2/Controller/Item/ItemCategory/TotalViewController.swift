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
    
    var totalItems: [ItemList] = []
    var foodItems: [ItemList] = []
    var medicineItems: [ItemList] = []
    var makeupItems: [ItemList] = []
    var necessaryItems: [ItemList] = []
    var othersItems: [ItemList] = []

    override func viewDidLoad() {
        super.viewDidLoad()

//        totalItems = foodItems + medicineItems + makeupItems + necessaryItems + othersItems
//        print("++++++++ total +++++++")
//        print(totalItems.count)
    }

    override func getData() {

//        let concurrentQueue = DispatchQueue(label: "com.total.groupqueue", qos: .default, attributes: .concurrent)

//        concurrentQueue.async {

//        let taskGroup = DispatchGroup()
//
//       
//        
////        concurrentQueue.async(group: taskGroup) {
//        
//        
//        taskGroup.enter()
//        
//        for iii in 0 ..< 2 {
//            makeupManager.getMakeupItems(success: { [weak self] nonTrashItems, _  in
//                
//                self?.makeupItems = nonTrashItems
//                print("++++++++ @@@@ ++++++++ \(iii)")
//                taskGroup.leave()
//                
//            }) { (error) in
//                
//                print(error)
//                taskGroup.leave()
//            }
//        }
//        
//        taskGroup.notify(queue: .main) {
//            print("++++++++ total +++++++")
//            print(self.totalItems.count)
//        }
        
            
            

//        }


    }

    private func getCategoryData(completion: @escaping () -> Void) {

        foodManager.getFoodItems(success: { [weak self] nonTrashItems, _  in

            self?.foodItems = nonTrashItems

        }) { (error) in

            print(error)
        }

        medicineManager.getMedicineItems(success: { [weak self] nonTrashItems, _  in

            self?.medicineItems = nonTrashItems

        }) { (error) in

            print(error)
        }

        makeupManager.getMakeupItems(success: { [weak self] nonTrashItems, _  in

            self?.makeupItems = nonTrashItems

        }) { (error) in

            print(error)
        }

        necessaryManager.getNecessaryItems(success: { [weak self] nonTrashItems, _  in

            self?.necessaryItems = nonTrashItems

        }) { (error) in

            print(error)
        }

        othersManager.getOthersItems(success: { [weak self] nonTrashItems, _  in

            self?.othersItems = nonTrashItems

        }) { (error) in

            print(error)
        }

        completion()
    }

}
