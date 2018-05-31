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
    
    @IBOutlet weak var alertTableView: UITableView!
    var items: [ItemList] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setNavBackground()
        
        getAlertDate()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = []
        getAlertDate()
        alertTableView.reloadData()
    }
    
    
    func getAlertDate() {
        
        do {
            let realm = try Realm()
            let dateformatter: DateFormatter = DateFormatter()
            dateformatter.dateFormat = "yyyy - MM - dd"
            let currentString = dateformatter.string(from: Date())
            let currentPoint: Date = dateformatter.date(from: currentString)!
            let order = realm.objects(ItemInfoObject.self).filter("alertDateFormat <= %@", currentPoint) // TODO: SORT
            
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
                items.append(info)
            }
           
            print("@@@ fileURL @@@: \(realm.configuration.fileURL)")
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func deleteAlertData(alertdate: String, createdate: String, name: String) {
        
        do {
            let realm = try Realm()
            let deleteInfo = NSPredicate(format: "alertDate == %@ AND createDate == %@ AND name == %@", "\(alertdate)", "\(createdate)", "\(name)")
            let order = realm.objects(ItemInfoObject.self).filter(deleteInfo)
            
            try realm.write {
                realm.delete(order)
            }
        } catch let error as NSError {
            print(error)
        }
        
    }
    
}


extension AlertListViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlertTableViewCell.self), for: indexPath) as? AlertTableViewCell {
            cell.nameLabel.text = items[indexPath.row].name
            cell.enddateLabel.text = "有效期限到 \(items[indexPath.row].endDate)"
            let alertday = abs(calculateAlertDay(alertdate: items[indexPath.row].alertDate))
            cell.alertdateLabel.text = "\(alertday)日"
            cell.itemImageView.sd_setImage(with: URL(string: items[indexPath.row].imageURL))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = UIStoryboard.itemDetailStoryboard().instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }
        controller.list = items[indexPath.row]
        controller.index = indexPath.row
        show(controller, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let name = items[indexPath.row]
        
        if editingStyle == .delete {
            
            deleteAlertData(alertdate: items[indexPath.row].alertDate, createdate: items[indexPath.row].createDate, name: items[indexPath.row].name)

            items.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            print("deleted item is: \(name)")
        }
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "刪除"
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
            color2: UIColor(red: 244/255.0, green: 238/255.0, blue: 225/255.0, alpha: 1.0),
            color3: UIColor(red: 244/255.0, green: 238/255.0, blue: 225/255.0, alpha: 1.0)
        )
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: - ALERTDATE CALCULATE -
    func calculateAlertDay(alertdate: String) -> Int {
        let dateformatter: DateFormatter = DateFormatter()
        dateformatter.dateFormat = "yyyy - MM - dd"
        let eString = alertdate
        let endPoint: Date = dateformatter.date(from: eString)!
        let sString = dateformatter.string(from: Date())
        let startPoint: Date = dateformatter.date(from: sString)!
        let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components = gregorianCalendar.components(.day, from: startPoint, to: endPoint, options: NSCalendar.Options(rawValue: 0))
        if let alertday = components.day {
            return alertday
        } else {
            return 0
        }
    }

    
}
