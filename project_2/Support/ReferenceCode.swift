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
    
    
    
    
    func setNavBackground() {
        navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
        navigationController?.navigationBar.layer.shadowRadius = 5
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = navigationController?.navigationBar.bounds
        // take into account the status bar
        updatedFrame?.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(bounds: updatedFrame!)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}


extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [UIColor.init(red: 120/255.0, green: 48/255.0, blue: 184/255.0, alpha: 1.0).cgColor, UIColor.init(red: 51/255.0, green: 164/255.0, blue: 204/255.0, alpha: 1.0).cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }
}
