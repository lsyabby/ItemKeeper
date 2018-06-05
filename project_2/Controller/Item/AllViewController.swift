//
//  AllViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/4.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class AllViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var myScrollView: UIScrollView!
    let testVCs = [TotalViewController(), FoodViewController(), MedicineViewController(), MakeupViewController(), NecessaryViewController(), OthersViewController()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myScrollView.delegate = self
        
        for category in testVCs {
            switch category {
            case TotalViewController():
                forCategorySwitch(itemType: ListCategory.total)
                
            case FoodViewController():
                forCategorySwitch(itemType: ListCategory.food)
                
            case MedicineViewController():
                forCategorySwitch(itemType: ListCategory.medicine)
                
            case MakeupViewController():
                forCategorySwitch(itemType: ListCategory.makeup)
                
            case NecessaryViewController():
                forCategorySwitch(itemType: ListCategory.necessary)
                
            default:
                forCategorySwitch(itemType: ListCategory.others)
            }
        }
        
    }
    
    func forCategorySwitch(itemType: ListCategory) {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        let storyboard = UIStoryboard(name: "ItemList", bundle: nil)
        guard let itemVC = storyboard.instantiateViewController(withIdentifier: String(describing: ItemCategoryViewController.self)) as? ItemCategoryViewController else { return }
        itemVC.dataType = itemType
        addChildViewController(itemVC)
        let originX: CGFloat = CGFloat(5) * width
        itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
        myScrollView.addSubview(itemVC.view)
        itemVC.didMove(toParentViewController: self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        print(width)
        let height = bounds.size.height
        var idx = 0
        for itemVC in testVCs {
            let originX: CGFloat = CGFloat(idx) * width
            itemVC.view.frame = CGRect(x: originX, y: 0, width: width, height: height)
            idx += 1
        }
    }
    
}
