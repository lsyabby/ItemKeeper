//
//  IKConstants.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/17.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import Foundation
import UIKit

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

        static let alphaBegin = CGFloat(0)
        static let alphaEnd = CGFloat(1)
        static let delay0 = 0.0
        static let delay3 = 0.3
        static let delay5 = 0.5

        static let backgroundColor = UIColor(red: 148/255.0, green: 17/255.0, blue: 0/255.0, alpha: 1.0)

        static let alertTitle = ""
        static let alertMessage = "請輸入電子信箱"
        static let placeholder = "電子信箱"
        static let cancelTitle = "取消"
        static let okTitle = "送出"
        static let animation = "simple_loader"

        static let cornerRadius = CGFloat(5)
        static let borderWidth = CGFloat(1)
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

    struct ItemCategoryRef {
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

        static let collectionViewNib = "CategoryCollectionViewCell"
        static let smConstant = CGFloat(-300)
        static let smShadowColor = UIColor.black.cgColor
        static let smShadowOpacity = Float(0.3)
        static let smShadowOffset = CGSize(width: 5, height: 0)

        static let navTintColor = UIColor(displayP3Red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1.0)
        static let navShadowOffset = CGSize(width: 0, height: 2)
        static let navShadowOpacity = Float(0.3)
        static let navShadowRadius = CGFloat(5)
        static let navShadowColor = UIColor.black.cgColor
        static let gestureConstant = CGFloat(0)

        static let delay3 = 0.3
        static let gesturePointX = CGFloat(150)
        static let updatedFrameHeight = CGFloat(20)
        static let layoutItemSpacing = CGFloat(0)
        static let layoutLineSpacing = CGFloat(10)
        static let layoutInset = CGFloat(10)

        static let allcategoryVC = "AllCategoryVC"
    }

    struct AllCategoryRef {
        static let notiName = "AddItem"
        static let notiPass = "PASS"

        static let tableViewNib = "ItemListTableViewCell"
    }

    struct ItemTableViewCellRef {
        static let backgroundViewColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8)
        static let shadowOffset = CGSize(width: -1, height: 1)
        static let shadowOpacity = Float(0.2)
        static let remainString = "還剩"
        static let dayString = "天"
        static let priceString = "元"
    }

}
