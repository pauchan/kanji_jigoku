//
//  PRDatabaseHelper.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/09.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//


import UIKit
import CoreData

class PRDatabaseHelper
{
    
    func dowloadDbFile() -> Bool
    {
        
        let stringURL : String = "http://serwer1456650.home.pl/clientDB.db"
        let url : NSURL = NSURL(string: stringURL)!

        let urlData : NSData = NSData(contentsOfURL: url)!
        
        var paths : NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = (paths[0] as? String)!
        
        let filePath : String = documentsDirectory.stringByAppendingPathComponent("clientDB.db")
            
        return  urlData.writeToFile(filePath, atomically: true)
        
        
        //return false

    }
    
    
    
    func parseDb() -> Bool
    {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = documentsFolder.stringByAppendingPathComponent("clientDB.db")
        
        let database = FMDatabase(path: path)
        
        if !database.open() {
            println("Unable to open database")
            return false
        }
        
        if parseCharacters(database)
        {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "Character")
            
            var error : NSError?
            let fetchedRequest = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
            
            if let results = fetchedRequest as? [Character]
            {
                println("succeeded")
                println(results.count)
                for ch in results
                {
                    println(ch.kanji)
                }
            }
        }
        else
        {
            println("failed to parse characters")
        }
        
        return true
    }

    
    func parseCharacters(database : FMDatabase) -> Bool
    {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let entity = NSEntityDescription.entityForName("Character", inManagedObjectContext: managedContext)!
    
    if let rs = database.executeQuery("select * from znaki", withArgumentsInArray: nil) {
        while rs.next() {
            
            let character = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as Character
            
            character.kanji = rs.stringForColumnIndex(0)
            character.alternativeKanji = rs.stringForColumnIndex(1)
            character.strokeCount = rs.intForColumnIndex(2)
            character.radical = rs.intForColumnIndex(3)
            character.alternativeRadical = rs.intForColumnIndex(4)
            character.meaning = rs.stringForColumnIndex(5)
            // skipping columns with index 6 (pinyin) and index 7 (nonori)
            character.note = rs.stringForColumnIndex(8)
            character.relatedKanji = rs.intForColumnIndex(9)
            character.lesson = rs.intForColumnIndex(10)
            character.level = rs.intForColumnIndex(11)
            character.kanjiId = rs.intForColumnIndex(12)
        }
    } else {
        println("select failed: \(database.lastErrorMessage())")
        return false
    }
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return false
        }
        
    return true
    
    }
}



//if !database.executeUpdate("create table test(x text, y text, z text)", withArgumentsInArray: nil) {
//    println("create table failed: \(database.lastErrorMessage())")
//}
//
//if !database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", withArgumentsInArray: ["a", "b", "c"]) {
//    println("insert 1 table failed: \(database.lastErrorMessage())")
//}
//
//if !database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", withArgumentsInArray: ["e", "f", "g"]) {
//    println("insert 2 table failed: \(database.lastErrorMessage())")
//}
//

//
//
//
//}