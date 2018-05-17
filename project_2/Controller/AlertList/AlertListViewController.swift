//
//  AlertListViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import UserNotifications


class AlertListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var itemInfo: ItemList?

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - NOTIFICATION - get alert date info
//        let notificationAlert = Notification.Name("AlertDateInfo")
        NotificationCenter.default.addObserver(self, selector: #selector(getAlertDate(noti:)), name: Notification.Name("AlertDateInfo"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getAlertDate(noti: Notification) {
        if let pass = noti.userInfo!["INFO"] as? String {
            //        if let pass = noti.userInfo!["INFO"] as? ItemList {
            //            self.itemInfo = pass
            let content = UNMutableNotificationContent()
            //            content.body = "\(pass.name) 的有效期限到 \(pass.endDate) 喔!!!"
            content.body = pass
            content.badge = 1
            content.sound = UNNotificationSound.default()
            
            //            let dateformatter: DateFormatter = DateFormatter()
            //            dateformatter.dateFormat = "MMM dd, yyyy"tring)!
            //            let alertDate: Date = dateformatter.date(from: pass.alertDate)!
            //            let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            //            let components = gregorianCalendar.components([.year, .month, .day], from: alertDate)
            print("========= components ========")
            //            print("\(components.year) \(components.month) \(components.day)")
            //            print("\(components.calendar) \(components.date)")
            
            //            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "alertDateNotification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                print("build alertdate notificaion successful !!!")
            }
        }
    }
    
}


extension AlertListViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // ???
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell() // ???
    }
    
    
}
