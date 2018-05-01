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
    case instock
    case alertList
    case profile
    case sss
    
    func controller() -> UIViewController {
        switch self {
        case .itemList: return UIStoryboard.itemListStoryboard().instantiateInitialViewController()!
        case .instock: return  UIStoryboard.instockStoryboard().instantiateInitialViewController()!
        case .alertList: return UIStoryboard.alerListStoryboard().instantiateInitialViewController()!
        case .profile: return UIStoryboard.profileStoryboard().instantiateInitialViewController()!
        case .sss: return UIStoryboard.sssStoryboard().instantiateInitialViewController()!
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .itemList: return #imageLiteral(resourceName: "032-list")
        case .instock: return #imageLiteral(resourceName: "031-archive-black-box")
        case .alertList: return #imageLiteral(resourceName: "030-bell")
        case .profile: return #imageLiteral(resourceName: "026-social-3")
        case .sss: return #imageLiteral(resourceName: "016-gift-box")
        }
    }
    
    func selectedImage() -> UIImage {
        switch self {
        case .itemList: return #imageLiteral(resourceName: "032-list").withRenderingMode(.alwaysTemplate)
        case .instock: return #imageLiteral(resourceName: "031-archive-black-box").withRenderingMode(.alwaysTemplate)
        case .alertList: return #imageLiteral(resourceName: "030-bell").withRenderingMode(.alwaysTemplate)
        case .profile: return #imageLiteral(resourceName: "026-social-3").withRenderingMode(.alwaysTemplate)
        case .sss: return #imageLiteral(resourceName: "016-gift-box").withRenderingMode(.alwaysTemplate)
        }
    }
}


class TabBarViewController: UITabBarController {
    
    let tabs: [TabBar] = [.itemList, .instock, .alertList, .profile, .sss]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTab() {
//        tabBar.tintColor = UIColor(named: "47B9AD")
        tabBar.tintColor = UIColor.brown
        var controllers: [UIViewController] = []
        for tab in tabs {
            let controller = tab.controller()
            let item = UITabBarItem(title: nil, image: tab.image(), selectedImage: tab.selectedImage())
            item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
            controller.tabBarItem = item
            controllers.append(controller)
        }
        setViewControllers(controllers, animated: false)
    }

}
