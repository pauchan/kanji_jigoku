//
//  PRStringExtensionTest.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/23.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit
import XCTest

class PRStringExtensionTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testShouldBeRomajiString() {
        // This is an example of a functional test case.
        let romajiString = "ThisIsRomajiString"
        XCTAssert(romajiString.isRomaji(), "This is romaji string")
    }
    
    func testShouldNOTBeRomajiString() {
        // This is an example of a functional test case.
        let notRomajiString = "これはロマじではない"
        XCTAssertFalse(notRomajiString.isRomaji(), "This is NOT romaji string")
    }
    
    func testMixedShouldNotBeRomajiString() {
        // This is an example of a functional test case.
        let mixedString = "これはmieszanyString"
        XCTAssertFalse(mixedString.isRomaji(), "This mixed string (not romaji)")
    }

    
    func testMixedShouldNotBeRomajiString2() {
        // This is an example of a functional test case.
        let mixedString = "mieszanyStringこれは"
        XCTAssertFalse(mixedString.isRomaji(), "This mixed string (not romaji)")
    }
    
//    func testPlainHiragana() {
//        let testString = "た（べる）";
//        XCTAssertEqual(testString.plainHiragana(), "たべる")
//    }
//    
//    func testExplained() {
//        let testString = "た（べる）";
//        let kanji = "食"
//        XCTAssertEqual(testString.kanjiWithOkurigana(kanji), "食べる")
//    }
}


