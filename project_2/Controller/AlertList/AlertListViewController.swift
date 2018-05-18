//
//  AlertListViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import UserNotifications


class AlertListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: [ItemList] = []
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
//            if granted {
//                print("允許")
//            } else {
//                print("不允許")
//            }
//        }
        
//        getTotalData()
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
            print("======= get pending notification ========")
            print(request)
        }
        
        UNUserNotificationCenter.current().getDeliveredNotifications { (noti) in
            print("======= get delivered noti ========")
            print(noti)
        }
//        print("======= alert data ========")
//        print(items)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
            print("======= get pending notification 0 ========")
            for rrr in request{
                print(rrr)
            }
        }
        
        UNUserNotificationCenter.current().getDeliveredNotifications { (noti) in
            print("======= get delivered noti 0 ========")
            for nnn in noti {
                print(nnn)
            }
        }
        
    }
    
    func getAlertDate() {
        
//        let content = UNMutableNotificationContent()
//        content.body = "\(pass.name) 的有效期限到 \(pass.endDate) 喔!!!"
//        content.badge = 1
//        content.sound = UNNotificationSound.default()
//
//        let dateformatter: DateFormatter = DateFormatter()
//        dateformatter.dateFormat = "MMM dd, yyyy"
//        let alertDate: Date = dateformatter.date(from: pass.alertDate)!
//        let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
//        let components = gregorianCalendar.components([.year, .month, .day], from: alertDate)
//        print("========= components ========")
//        print("\(components.year) \(components.month) \(components.day)")
//        print("\(components.calendar) \(components.date)")
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "alertDateNotification", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            print("build alertdate notificaion successful !!!")
//        }
    }
    
    
}


extension AlertListViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // ???
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell() // ???
    }
    
    func getTotalData() {
        ref = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        self.ref.child("items/\(userId)").queryOrdered(byChild: "createdate").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            var allItems = [ItemList]()
            for item in value {
                if let list = item.value as? [String: Any] {
                    let createdate = list["createdate"] as? String
                    let image = list["imageURL"] as? String
                    let name = list["name"] as? String
                    let itemId = list["id"] as? Int
                    let category = list["category"] as? ListCategory.RawValue
                    let enddate = list["enddate"] as? String
                    let alertdate = list["alertdate"] as? String
                    let instock = list["instock"] as? Int
                    let isInstock = list["isInstock"] as? Bool
                    let alertinstock = list["alertInstock"] as? Int ?? 0
                    let price = list["price"] as? Int
                    let otehrs = list["others"] as? String ?? ""
                    
                    let info = ItemList(createDate: createdate!, imageURL: image!, name: name!, itemId: itemId!, category: category!, endDate: enddate!, alertDate: alertdate!, instock: instock!, isInstock: isInstock!, alertInstock: alertinstock, price: price!, others: otehrs)
                    allItems.append(info)
                }
            }
            self.items = allItems
        }
    }
    
}
