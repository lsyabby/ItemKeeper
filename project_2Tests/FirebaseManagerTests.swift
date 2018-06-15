//
//  FirebaseManagerTests.swift
//  project_2Tests
//
//  Created by 李思瑩 on 2018/6/13.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import XCTest
@testable import project_2

class FirebaseManagerTests: XCTestCase {

    enum StubCategoryList: String, StringGettable {

        case correctCategoty = "食品"
        
        case incorrectCategory = ""

        func getString() -> String {
        
            return self.rawValue
        }
    }

    var firebaseManagerTest: FirebaseManager!

    override func setUp() {

        super.setUp()

        firebaseManagerTest = FirebaseManager()
    }

    override func tearDown() {

        firebaseManagerTest = nil

        super.tearDown()
    }

    func test_GetCategoryData_IsCorrectOutput() {

        // 1. given
        let expEmpty: [String] = []
        
        var outputValue: [String] = []
        
        let inputCategory = StubCategoryList.correctCategoty

        // 2. when
        let expTest = expectation(description: "test for dictGetCategoryData")

        firebaseManagerTest.dictGetCategoryData(by: inputCategory) { (rawData) in

            for iii in rawData.keys {
               
                outputValue.append(iii)
            }

            expTest.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // 3. then
        XCTAssertNotEqual(outputValue, expEmpty)
    }

//    func test_AddNewData_IsAdd() {
//
//        // 1. given
//        let photo: UIImage = #imageLiteral(resourceName: "profile_placeholder")
//        let value: [String: Any] = [:]
//
//        // 2. when
//        let expTest = expectation(description: "test for addNewData")
//
//        firebaseManagerTest.addNewData(photo: photo, value: value) { (info) in
//
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
