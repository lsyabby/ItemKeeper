//
//  ReferenceCode.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import FirebaseAuth

class Aaa: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.presentLoggedInScreen()
        }
    }

    // present logged in screen
    func presentLoggedInScreen() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loggedInVC: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        self.present(loggedInVC, animated: true, completion: nil)
    }

    // remain day calculate
    func calculateRemainDay(enddate: String) -> Int {
        let dateformatter: DateFormatter = DateFormatter()
        dateformatter.dateFormat = "yyyy - MM - dd"
        let eString = enddate
        let endPoint: Date = dateformatter.date(from: eString)!
        let sString = dateformatter.string(from: Date())
        let startPoint: Date = dateformatter.date(from: sString)!
        let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components = gregorianCalendar.components(.day, from: startPoint, to: endPoint, options: NSCalendar.Options(rawValue: 0))
        if let remainday = components.day {
//            itemRemaindayLabel.text = "還剩 \(rrr) 天"
            return remainday
        } else {
            return 0
        }
    }

    // MARK: SAVE IN Realm
    //                do {
    //                    let realm = try Realm()
    //                    let order: Order = Order()
    //                    order.name = content.title
    //                    order.endDate = content.body
    //                    guard let createdate = content.userInfo["createDate"] as? String else { return }
    //                    order.createDate = createdate
    //                    order.imageUrl = String(describing: content.attachments[0].url)
    //                    print(content.attachments)
    //
    //                    try realm.write {
    //                        realm.add(order)
    //                    }
    //                    print("@@@ fileURL @@@: \(realm.configuration.fileURL)")
    //                } catch let error as NSError {
    //                    print(error)
    //                }

    // MARK: ADDITEM
    //        guard let photo = self.newImage else {
    //            if let imageVC = UIStoryboard.addItemStoryboard().instantiateViewController(withIdentifier: String(describing: AddImageViewController.self)) as? AddImageViewController {
    //                imageVC.addImageView.layer.cornerRadius = 2
    //                imageVC.addImageView.layer.borderWidth = 1
    //                imageVC.addImageView.layer.borderColor = UIColor.red.cgColor
    //            }
    //            return
    //        }

}
