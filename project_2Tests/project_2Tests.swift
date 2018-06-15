//
//  project_2Tests.swift
//  project_2Tests
//
//  Created by 李思瑩 on 2018/6/13.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import XCTest
@testable import project_2

class FirebaseManagerTests: XCTestCase {
    
    var firebaseManagerTest: FirebaseManager!
    
    override func setUp() {

        super.setUp()
        
        firebaseManagerTest = FirebaseManager()
    }

    override func tearDown() {

        firebaseManagerTest = nil
        
        super.tearDown()
    }
    
    func test_GetCategoryData_IsCorrectCount() {
        
        // 1. given
        let categoryString = "食品"
        
        var value: Int = 0

        // 2. when
        let expTest = expectation(description: "test for dictGetCategoryData")
        
        firebaseManagerTest.dictGetCategoryData(by: categoryString) { (rawData) in

            var nonTrashItems = [ItemList]()
            
            var trashItems = [ItemList]()

            for item in rawData {

                if let info = ItemList.createItemList(data: item.value) {

                    let remainday = DateHandler.calculateRemainDay(enddate: info.endDate)

                    if remainday < 0 {
                        
                        trashItems.append(info)
                    
                    } else {
                        
                        nonTrashItems.append(info)
                    }
                    
                } else {
                    
                    print("====== error ======")
                }
            }
            
            expTest.fulfill()
            
            value = nonTrashItems.count
        }
        
        waitForExpectations(timeout: 5, handler: nil)

        // 3. then
        XCTAssertEqual(value, 2)
    }
    
//    func testAddNewData() {
//
//        // 1. given
//        let photo: UIImage = #imageLiteral(resourceName: "profile_placeholder")
//        let value: [String: Any] = [:]
//
//        // 2. when
//        let expTest = expectation(description: "test for addNewData")
//
//        firebaseManagerTest.addNewData(photo: photo, value: value) { (info) in
//            expTest.fulfill()
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//
//        // 3. then
//        XCTAssertEqual(<#T##expression1: Equatable##Equatable#>, <#T##expression2: Equatable##Equatable#>)
//    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

