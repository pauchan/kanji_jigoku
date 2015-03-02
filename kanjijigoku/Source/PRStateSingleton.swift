//
//  PRStateSingleton.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit
import CoreData


class PRStateSingleton {

    var currentLevel = 1
    var currentLesson : Int = 1{
    
        didSet{
        
            println("setter called")
            NSNotificationCenter.defaultCenter().postNotificationName("PRKanjiJigokuLessonUpdated", object: nil)
        }
    }
    
    var levelArray = [Int]()
    var lessonArray = [Int]()
    
    var filterOn : Bool = false
    var filterLesson : Int = 1
    var filterLevel : Int = 1
    
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
