//
//  PRStateSingleton.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation


class PRStateSingleton {
    
    var lessonArray = NSArray()
    var levelArray = NSArray()
    var currentLesson = 1
    var currentLevel = 1
    
    class var sharedInstance: PRStateSingleton {
        struct Static {
            static var instance: PRStateSingleton?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = PRStateSingleton()
        }
        
        return Static.instance!
    }
}