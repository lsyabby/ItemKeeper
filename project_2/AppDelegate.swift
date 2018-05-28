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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let shared = (UIApplication.shared.delegate as? AppDelegate)!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        UNUserNotificationCenter.current().delegate = self
        
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
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        completionHandler([.badge, .sound, .alert])
//
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler:  @escaping () -> Void) {
//
//        let content = response.notification.request.content
//        print("title \(content.title)")
//        print("userInfo \(content.userInfo)")
//
////        UNUserNotificationCenter.current().getDeliveredNotifications { (noti) in
////            print("======= get delivered noti 0 ========")
////            for nnn in noti {
////                print(nnn)
////            }
////        }
//        completionHandler()
//
//    }
}
