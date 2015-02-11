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
    
    var currentLesson = 1
    var currentLevel = 1
    
    var lessonArray : NSArray {
    
    get{
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Character")
        let entity = NSEntityDescription.entityForName("Character", inManagedObjectContext: managedContext)!
        //fetchRequest.resultType =
        fetchRequest.propertiesToFetch = ["lesson"]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.predicate = NSPredicate(fromMetadataQueryString: "level=\(currentLevel)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lesson", ascending: true)]
        fetchRequest.resultType = .DictionaryResultType;
        let outArray: NSArray = managedContext.executeFetchRequest(fetchRequest, error: nil)!
        return outArray
        
        }
    }

    var levelArray: NSArray
        {
        get{
            
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Character")
    let entity = NSEntityDescription.entityForName("Character", inManagedObjectContext: managedContext)!
    //fetchRequest.resultType =
    fetchRequest.propertiesToFetch = ["level"]
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true)]
    fetchRequest.returnsDistinctResults = true
    fetchRequest.resultType = .DictionaryResultType;
    let outArray: NSArray = managedContext.executeFetchRequest(fetchRequest, error: nil)!
    return outArray
    
    }
    }
    
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
