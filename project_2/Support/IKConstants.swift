//
//  IKConstants.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/17.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation

struct IKConstants {

    struct DateRef {
        static let remaindayPoint: Int = 0
        static let dateFormat = "yyyy - MM - dd"
    }
    
    struct LoginRef {
        static let userIdString = "User_ID"
        static let name = "name"
        static let email = "email"
        static let profileImageUrl = "profileImageUrl"
        static let users = "users"
        static let registerMessage = "請到註冊信箱進行驗證，再行登入"
        static let okString = "了解"
    }
    
    struct FirebaseRef {
        static let itemsChild = "items"
        static let metadataContentType = "image/png"
        static let error = "Error"
        static let imageUrl = "imageURL"
        static let addItem = "AddItem"
        static let pass = "PASS"
        static let category = "category"
        static let profile = "profile"
        static let profileImageUrl = "profileImageUrl"
        static let users = "users"
        static let createdate = "createdate"
    }

    struct RealmRef {
        static let alertCreateDate = "alertCreateDate"
    }
    
    struct ItemCategory {
        static let byNew = "最新加入優先"
        static let byLess = "剩餘天數由少至多"
        static let byMore = "剩餘天數由多至少"
        static let ddmLeadConstant = 45
        static let ddmTrailConstant = -45
        static let ddmTopConstant = 8
        static let ddmHeightConstant = 33
        static let tvTopInset = 0
        static let tvLeftInset = 0
        static let tvBottomInset = 149
        static let tvRightInset = 0
        static let tvLeadConstant = 0
        static let tvTrailConstant = 0
        static let tvTopConstant = 8
    }
}
