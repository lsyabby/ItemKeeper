//
//  DateHandler.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/5.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation

struct DateHandler {

    static func calculateRemainDay(enddate: String) -> Int {

        let dateformatter: DateFormatter = DateFormatter()

        dateformatter.dateFormat = "yyyy - MM - dd"

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
