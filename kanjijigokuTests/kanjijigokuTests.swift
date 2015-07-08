//
//  kanjijigokuTests.swift
//  kanjijigokuTests
//
//  Created by Pawel Rusin on 2/7/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import UIKit
import XCTest

class kanjijigokuTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRemoveReferenceSubstringWithNoReference() {
    
        let testString = "dsfdsafgdghbgrbf"
        let shortened = testString.removeReferenceSubstring()
        XCTAssertEqual(testString, shortened, "proper shortening for string with no reference")
    }
    
    func testRemoveReferenceSubstringWithOneReference() {
        
        let comparableString = "dsfdsafgdghbgrbf"
        let testString = "dsfdsafgdgh|234324234|bgrbf"
        let shortened = testString.removeReferenceSubstring()
        XCTAssertEqual(shortened, comparableString, "proper shortening for string with one reference")
    }

    
    func testRemoveReferenceSubstringWithTwoReference() {
        
        let comparableString = "dsfdsafgdghbgrbf"
        let testString = "d|fre45tg|sfdsafgdgh|234324234|bgrbf"
        let shortened = testString.removeReferenceSubstring()
        XCTAssertEqual(shortened, comparableString, "proper shortening for string with two reference")
    }
}
