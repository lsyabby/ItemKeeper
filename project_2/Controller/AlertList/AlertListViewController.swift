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
import RealmSwift
import SDWebImage

struct OrderType {
    var createDate: String
    var name: String
    var endDate: String
    var imageUrl: String
}


class AlertListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: [OrderType] = []
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBackground()
        
        getAlertDate()
        
    }
    
    
    func getAlertDate() {
        
        do {
            let realm = try Realm()
            let order = realm.objects(Order.self)
            
            print("===== alert item ======")
            for iii in order {
                print(iii)
                let info = OrderType(createDate: iii.createDate, name: iii.name, endDate: iii.endDate, imageUrl: iii.imageUrl)
                items.append(info)
            }
            print(items)
           
            print("@@@ fileURL @@@: \(realm.configuration.fileURL)")
        } catch let error as NSError {
            print(error)
        }
        
    }
    
}


extension AlertListViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count // ???
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlertTableViewCell.self), for: indexPath) as? AlertTableViewCell {
            cell.nameLabel.text = items[indexPath.row].name
            cell.enddateLabel.text = items[indexPath.row].endDate
//            cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageUrl))
            return cell
        }
        return UITableViewCell() // ???
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func setNavBackground() {
        navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
        navigationController?.navigationBar.layer.shadowRadius = 5
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = navigationController?.navigationBar.bounds
        // take into account the status bar
        updatedFrame?.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(
            bounds: updatedFrame!,
            color1: UIColor(red: 244/255.0, green: 238/255.0, blue: 225/255.0, alpha: 1.0),
            //            UIColor(red: 100/255.0, green: 186/255.0, blue: 226/255.0, alpha: 1.0),
            color2: UIColor(red: 244/255.0, green: 238/255.0, blue: 225/255.0, alpha: 1.0),
            //            UIColor(red: 244/255.0, green: 218/255.0, blue: 222/255.0, alpha: 1.0),
            color3: UIColor(red: 244/255.0, green: 238/255.0, blue: 225/255.0, alpha: 1.0)
            //            UIColor(red: 182/255.0, green: 222/255.0, blue: 215/255.0, alpha: 1.0)
        )
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
