//
//  DateHandler.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/5.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import UIKit

struct DateHandler {

    static func calculateRemainDay(enddate: String) -> Int {

        let dateformatter: DateFormatter = DateFormatter()

        dateformatter.dateFormat = IKConstants.DateRef.dateFormat

        let eString = enddate

        let endPoint: Date = dateformatter.date(from: eString)!

        let sString = dateformatter.string(from: Date())

        let startPoint: Date = dateformatter.date(from: sString)!

        let gregorianCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

        let components = gregorianCalendar.components(.day, from: startPoint, to: endPoint, options: NSCalendar.Options(rawValue: 0))

        if let remainday = components.day {

            return remainday

        } else {

            return 0
        }
    }

    // MARK: - ALERTDATE CALCULATE -
    static func calculateAlertDay(alertdate: String) -> Int {

        let dateformatter: DateFormatter = DateFormatter()

        dateformatter.dateFormat = IKConstants.DateRef.dateFormat

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

    static func setDatePickerToolBar(dateTextField: UITextField, view: UIView, btnAction: @escaping () -> UIBarButtonItem) {

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height / 6, width: view.frame.size.width, height: 40.0))

        toolBar.layer.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height - 20.0)

        toolBar.barStyle = UIBarStyle.blackTranslucent

        toolBar.tintColor = UIColor.white

        toolBar.backgroundColor = UIColor.black

        let okBarBtn = btnAction()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: view.frame.size.height))

        label.font = UIFont(name: "Helvetica", size: 15)

        label.backgroundColor = UIColor.clear

        label.textColor = UIColor.white

        label.text = "請選擇日期"

        label.textAlignment = .center

        let textBtn = UIBarButtonItem(customView: label)

        toolBar.setItems([flexSpace, textBtn, flexSpace, okBarBtn], animated: true)

        dateTextField.inputAccessoryView = toolBar

        dateTextField.clearButtonMode = .whileEditing
    }
}
