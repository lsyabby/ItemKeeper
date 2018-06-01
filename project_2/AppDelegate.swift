//
//  AppDelegate.swift
//  project_2
//
//  Created by 李思瑩 on 2018/4/30.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications
import FirebaseAuth
import Firebase
import IQKeyboardManagerSwift
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let shared = (UIApplication.shared.delegate as? AppDelegate)!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        guard UserDefaults.standard.value(forKey: "User_ID") == nil else {
            switchToMainStoryBoard()
            return true
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        var alertItems: [ItemList] = []
        do {
            let realm = try Realm()
            let dateformatter: DateFormatter = DateFormatter()
            dateformatter.dateFormat = "yyyy - MM - dd"
            let currentString = dateformatter.string(from: Date())
            let currentPoint: Date = dateformatter.date(from: currentString)!
            let order = realm.objects(ItemInfoObject.self).filter("alertDateFormat <= %@", currentPoint).sorted(byKeyPath: "alertDateFormat", ascending: false)
            
            for iii in order {
                let info = ItemList(
                    createDate: iii.createDate,
                    imageURL: iii.imageURL,
                    name: iii.name,
                    itemId: iii.itemId,
                    category: iii.category,
                    endDate: iii.endDate,
                    alertDate: iii.alertDate,
                    instock: iii.instock,
                    isInstock: iii.isInstock,
                    alertInstock: iii.alertInstock,
                    price: iii.price,
                    others: iii.others)
                alertItems.append(info)
            }
            UIApplication.shared.applicationIconBadgeNumber = alertItems.count
        } catch let error as NSError {
            print(error)
        }
    
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func switchToLoginStoryBoard() {
        
        if !Thread.current.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.switchToLoginStoryBoard()
            }
            return
        }
        
        window?.rootViewController = UIStoryboard.loginStoryboard().instantiateInitialViewController()
    }
    
    func switchToMainStoryBoard() {
        
        if !Thread.current.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.switchToMainStoryBoard()
            }
            return
        }
        
        window?.rootViewController = UIStoryboard.mainStoryboard().instantiateInitialViewController()
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.badge, .sound, .alert])

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler:  @escaping () -> Void) {

        let content = response.notification.request.content
        guard let notiCreateDate = content.userInfo["createDate"] as? String,
            let notiImageURL = content.userInfo["imageURL"] as? String,
            let notiName = content.userInfo["name"] as? String,
            let notiID = content.userInfo["itemId"] as? Int,
            let notiCategory = content.userInfo["category"] as? ListCategory.RawValue,
            let notiEnddate = content.userInfo["endDate"] as? String,
            let notiAlertdate = content.userInfo["alertDate"] as? String,
            let notiInstock = content.userInfo["instock"] as? Int,
            let notiIsInstock = content.userInfo["isInstock"] as? Bool,
            let notiAlertInstock = content.userInfo["alertInstock"] as? Int,  // delete
            let notiPrice = content.userInfo["price"] as? Int,
            let notiOthers = content.userInfo["others"] as? String else { return }
            let info = ItemList(createDate: notiCreateDate, imageURL: notiImageURL, name: notiName, itemId: notiID, category: notiCategory, endDate: notiEnddate, alertDate: notiAlertdate, instock: notiInstock, isInstock: notiIsInstock, alertInstock: notiAlertInstock, price: notiPrice, others: notiOthers)
        
        guard let tabVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController,
            let naVC = tabVC.viewControllers![0] as? UINavigationController,
            let detailVC = UIStoryboard.itemDetailStoryboard().instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }
        detailVC.list = info
        naVC.popToRootViewController(animated: true)
        naVC.show(detailVC, sender: nil)
        
        completionHandler()

    }
}
