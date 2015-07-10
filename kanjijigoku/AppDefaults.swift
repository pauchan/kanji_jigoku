//
//  AppDefaults.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

let debugOn = true

let IS_IPAD = UIDevice.currentDevice().userInterfaceIdiom == .Pad
let IS_IPHONE = UIDevice.currentDevice().userInterfaceIdiom == .Phone
let IS_RETINA = UIScreen.mainScreen().scale >= 2.0

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

let kPRstarCharacter: Character = "\u{2B50}"

func debugLog(logMessage: String, filename: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__ ) {
    
    if debugOn {
        dispatch_async(dispatch_get_main_queue(),{
            println("\(filename.lastPathComponent)|\(function)|\(line): \(logMessage)")
        })
    }
}

func warningLog(logMessage: String, filename: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__ ) {
    dispatch_async(dispatch_get_main_queue(),{
        println("\(filename.lastPathComponent)|\(function)|\(line): \(logMessage)")
    })
}