//
//  AlertListViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class AlertListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var itemInfo: ItemList?

    override func viewDidLoad() {
        super.viewDidLoad()

        // notification - get alert date info
        let notificationAlert = Notification.Name("AlertDateInfo")
        NotificationCenter.default.addObserver(self, selector: #selector(getAlertDate(noti:)), name: notificationAlert, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension AlertListViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // ???
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell() // ???
    }
    
    @objc func getAlertDate(noti: Notification) {
        if let pass = noti.userInfo!["PASS"] as? ItemList {
            self.itemInfo = pass
        }
    }
    
}
