//
//  PRAuthTest.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 3/27/16.
//  Copyright © 2016 Pawel Rusin. All rights reserved.
//



import XCTest

class PRAuthTest: XCTestCase {
    
    func testUpdateAlertMessage() {
        XCTAssertEqual(PRDatabaseHelper().updateAlertMessage(nil, requestedToken: true), kFullAccessMessage)
        XCTAssertEqual(PRDatabaseHelper().updateAlertMessage(nil, requestedToken: false), kLimitedAccessMessage)
        XCTAssertEqual(PRDatabaseHelper().updateAlertMessage(true, requestedToken: true), nil)
        XCTAssertEqual(PRDatabaseHelper().updateAlertMessage(true, requestedToken: false), nil)
        XCTAssertEqual(PRDatabaseHelper().updateAlertMessage(false, requestedToken: false), nil)
        XCTAssertEqual(PRDatabaseHelper().updateAlertMessage(false, requestedToken: true), kFullAccessMessage)
    }
    
    func testReadAuthToken() {
        XCTAssertNil(PRDatabaseHelper().readAuthToken())
        UserDefaults.standard.set(false, forKey: "PRKanjiJigokuAuthKey")
        UserDefaults.standard.synchronize()
        XCTAssertFalse(PRDatabaseHelper().readAuthToken()!)
        UserDefaults.standard.set(true, forKey: "PRKanjiJigokuAuthKey")
        UserDefaults.standard.synchronize()
        XCTAssertTrue(PRDatabaseHelper().readAuthToken()!)
    }
}
