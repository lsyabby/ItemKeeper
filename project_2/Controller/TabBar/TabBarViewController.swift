//
//  TabBarViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/4/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

enum TabBar {
    case itemList
    case alertList
    case addItem
    case trash
    case all

    func controller() -> UIViewController {
        switch self {
        case .itemList: return UIStoryboard.itemListStoryboard().instantiateInitialViewController()!
        case .alertList: return UIStoryboard.alerListStoryboard().instantiateInitialViewController()!
        case .addItem: return UIStoryboard.addItemStoryboard().instantiateInitialViewController()!
        case .trash: return UIStoryboard.trashStoryboard().instantiateInitialViewController()!
        case .all: return AllCategoryViewController()
        }
    }

    func image() -> UIImage {
        switch self {
        case .itemList: return #imageLiteral(resourceName: "025-package-cube-box-for-delivery")
        case .alertList: return #imageLiteral(resourceName: "023-music-1")
        case .addItem: return #imageLiteral(resourceName: "003-interface-4")
        case .trash: return #imageLiteral(resourceName: "dog-poop")
        case .all: return #imageLiteral(resourceName: "003-interface-4")
        }
    }

    func selectedImage() -> UIImage {
        switch self {
        case .itemList: return #imageLiteral(resourceName: "025-package-cube-box-for-delivery").withRenderingMode(.alwaysTemplate)
        case .alertList: return #imageLiteral(resourceName: "023-music-1").withRenderingMode(.alwaysTemplate)
        case .addItem: return #imageLiteral(resourceName: "003-interface-4").withRenderingMode(.alwaysTemplate)
        case .trash: return #imageLiteral(resourceName: "dog-poop").withRenderingMode(.alwaysTemplate)
        case .all: return #imageLiteral(resourceName: "003-interface-4").withRenderingMode(.alwaysTemplate)
        }
    }
}

class TabBarViewController: UITabBarController {

    // MARK: - PASS TRASH ITEM LIST -
    var trashItem: [ItemList]?
    let tabs: [TabBar] = [.itemList, .addItem, .alertList, .trash]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTab()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupTab() {
        tabBar.tintColor = UIColor(red: 213/255.0, green: 100/255.0, blue: 124/255.0, alpha: 1.0)
        tabBar.barTintColor = UIColor.white
        var controllers: [UIViewController] = []
        for tab in tabs {
            let controller = tab.controller()
            let item = UITabBarItem(title: nil, image: tab.image(), selectedImage: tab.selectedImage())
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            controller.tabBarItem = item
            controllers.append(controller)
        }
        setViewControllers(controllers, animated: false)
    }

}
