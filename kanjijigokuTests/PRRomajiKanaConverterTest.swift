//
//  PRRomajiKanaConverterTest.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/23.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit
import XCTest

class PRRomajiKanaConverterTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRomajiToHiragara() {
        // This is an example of a functional test case.
        let conversion = PRRomajiKanaConverter().convert("Kaiwa", from: AlphabetType.Romaji, to: AlphabetType.Hiragana)
        XCTAssertEqual(conversion, "かいわ", "converting Kaiwa to かいわ")
    }

    func testEmptyString() {
        // This is an example of a functional test case.
        let conversion = PRRomajiKanaConverter().convert("", from: AlphabetType.Romaji, to: AlphabetType.Hiragana)
        XCTAssertEqual(conversion, "", "converting empty string")
    }
    
    func testHiraganaToRomaji() {
        // This is an example of a functional test case.
        let conversion = PRRomajiKanaConverter().convert("かいわ", from: AlphabetType.Hiragana, to: AlphabetType.Romaji)
        XCTAssertEqual(conversion, "kaiwa", "converting かいわ to kaiwa")
    }
    
    func testImproperRomajiToHiragana() {
    
        // This is an example of a functional test case.
        let conversion = PRRomajiKanaConverter().convert("klops", from: AlphabetType.Romaji, to: AlphabetType.Hiragana)
        XCTAssertEqual(conversion, "klおps", "converting klops to klおps")
    }

    func testAIUEOToHiragana() {
        
        // This is an example of a functional test case.
        let conversion = PRRomajiKanaConverter().convert("AIUEO", from: AlphabetType.Romaji, to: AlphabetType.Hiragana)
        XCTAssertEqual(conversion, "あいうえお", "converting AIUEO to あいうえお")
    }
    
    func testAIUEOToKatakana() {
        
        // This is an example of a functional test case.
        let conversion = PRRomajiKanaConverter().convert("AIUEO", from: AlphabetType.Romaji, to: AlphabetType.Katakana)
        XCTAssertEqual(conversion, "アイウエオ", "converting AIUEO to アイウエオ")
    }
    
}
