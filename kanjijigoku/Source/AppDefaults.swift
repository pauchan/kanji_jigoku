//
//  AppDefaults.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

let debugOn = true

let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
let IS_RETINA = UIScreen.main.scale >= 2.0

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

let appColor = UIColor.green

let kPRstarCharacter: Character = "\u{2B50}"

let scaleForDevice : CGFloat = (IS_IPAD) ? 2.0 : 1.0

let kPRKanjiJigokuAttributedBoldBig : [String : AnyObject] = [NSFontAttributeName : UIFont().appFontOfSize(20.0)]
let kPRKanjiJigokuAttributedSmall : [String : AnyObject] = [NSFontAttributeName : UIFont().appFontOfSize(14.0)]

func debugLog(_ logMessage: String, filename: String = #file, function: String = #function, line: Int = #line ) {
    
    if debugOn {
        DispatchQueue.main.async(execute: {
            print("\(filename)|\(function)|\(line): \(logMessage)")
        })
    }
}

func warningLog(_ logMessage: String, filename: String = #file, function: String = #function, line: Int = #line ) {
    DispatchQueue.main.async(execute: {
        print("\(filename)|\(function)|\(line): \(logMessage)")
    })
}
