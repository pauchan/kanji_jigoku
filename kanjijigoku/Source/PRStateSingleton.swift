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

    static let sharedInstance = PRStateSingleton()
    
    var currentLevel = 1
    var currentLesson : Int = 1{
        didSet{        
            NotificationCenter.default.post(name: Notification.Name(rawValue: "PRKanjiJigokuLessonUpdated"), object: nil)
        }
    }
    
    var levelArray = [Int]()
    var lessonArray = [Int]()
    
    var filterOn : Bool = false
    var filterLesson : Int = 1
    var filterLevel : Int = 1
    var extraMaterial: Bool = false
}
