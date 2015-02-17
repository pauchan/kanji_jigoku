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
    
    //func parseCharacters(database : FMDatabase) -> Bool
    var _timestamp : NSString = NSString()
    
    func syncDatabase()
    {
        if downloadDbFile()
        {
            let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let path = documentsFolder.stringByAppendingPathComponent("clientDB.db")
            
            let database = FMDatabase(path: path)
            
            if database.open()
            {
                if parseDb(database)
                {
                    println("parsed db succesfully")
                }
                else
                {
                    println("db parse failed")
                }
                database.close()
            }
            else
            {
                println("Unable to open database")
            }
        }
        else
        {
            println("Download db file failed")
        }
    }
    
    func downloadDbFile() -> Bool
    {
        
        let stringURL : String = "http://serwer1456650.home.pl/clientDB.db"
        
        // FIX!!!!  "!" operator works for now, but there should be some sort of nil-validation
        // why does the " if let url : ... {}" not working ???
        let url : NSURL = NSURL(string: stringURL)!

        let urlData : NSData = NSData(contentsOfURL: url)!
        
        var paths : NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = (paths[0] as? String)!
        
        let filePath : String = documentsDirectory.stringByAppendingPathComponent("clientDB.db")
            
        return  urlData.writeToFile(filePath, atomically: true)
        
    }
    
    func shouldUpdateDb(database : FMDatabase) -> Bool
    {
        
        if let appDbUpdate : NSString = NSUserDefaults.standardUserDefaults().objectForKey("PRKanjiJigokuDbUpdate") as? NSString
        {
            if let rs = database.executeQuery("select * from update_time", withArgumentsInArray: nil) {
                while rs.next() {
                    
                    _timestamp = rs.stringForColumnIndex(0)
                    //println(rs.stringForColumnIndex(0))
                    if(appDbUpdate.isEqualToString(_timestamp)){
                        
                        return false
                    }
                }
            } else {
                println("select failed: \(database.lastErrorMessage())")
                return false
            }
            
        }
        return true
    }
    
    func parseDb(database : FMDatabase) -> Bool
    {
        
        
        if(!shouldUpdateDb(database))
        {
            println("database up to date")
            return true
        }
        
        deleteObjects("Character")
        deleteObjects("Kunyomi")
        deleteObjects("Onyomi")
        deleteObjects("Sentence")
        deleteObjects("Example")
        deleteObjects("Radical")
        
        if !parseCharacters(database)
        {
            println("failed to parse characters")
            return false
        }
        
//        if !parseKunyomi(database)
//        {
//            println("failed to parse kunyomi")
//            return false
//        }
//        if !parseOnyomi(database)
//        {
//            println("failed to parse onyomi")
//            return false
//        }
//        if !parseExamples(database)
//        {
//            println("failed to parse examples")
//            return false
//        }
//        if !parseSentences(database)
//        {
//            println("failed to parse sentences")
//            return false
//        }
//        if !parseRadicals(database)
//        {
//            println("failed to parse radicals")
//            return false
//        }
        NSUserDefaults.standardUserDefaults().setObject(_timestamp, forKey: "PRKanjiJigokuDbUpdate")
        println("Update successful")
        
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
                    
                    character.kunyomis = parseKunyomi(database, character: character.kanji)
                    character.onyomis = parseOnyomi(database, character: character.kanji)
                    character.examples = parseExamples(database, character: character.kanji)
                    character.sentences = parseSentences(database, character: character.kanji)
                    character.radicals = parseRadicals(database, number: Int(character.radical))
                    
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
        
        func parseSentences(database : FMDatabase, character : String) -> NSSet
        {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let entity = NSEntityDescription.entityForName("Sentence", inManagedObjectContext: managedContext)!
            
            var outSet : NSMutableSet = NSMutableSet()
            
            if let rs = database.executeQuery("select * from zdania where kanji='\(character)'", withArgumentsInArray: nil) {
                while rs.next() {
                    
                    let sentence = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as Sentence
                    
                    sentence.kanji = rs.stringForColumnIndex(0)
                    sentence.example = rs.stringForColumnIndex(1)
                    sentence.sentence = rs.stringForColumnIndex(2)
                    sentence.meaning = rs.stringForColumnIndex(3)
                    sentence.code = rs.intForColumnIndex(4)
                    sentence.sentenceId = rs.intForColumnIndex(5)
                    
                    outSet.addObject(sentence)
                }
            } else {
                println("select failed: \(database.lastErrorMessage())")
            }
            
            return outSet.copy() as NSSet
            
        }
        
        func parseKunyomi(database : FMDatabase, character : String) -> NSSet
        {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let entity = NSEntityDescription.entityForName("Kunyomi", inManagedObjectContext: managedContext)!
            
            var outSet : NSMutableSet = NSMutableSet()
            
            if let rs = database.executeQuery("select * from kunyomi where kanji='\(character)'", withArgumentsInArray: nil) {
                while rs.next() {
                    
                    let kunyomi = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as Kunyomi
                    
                    kunyomi.kanji = rs.stringForColumnIndex(0)
                    kunyomi.reading = rs.stringForColumnIndex(1)
                    kunyomi.meaning = rs.stringForColumnIndex(2)
                    kunyomi.readingId = rs.intForColumnIndex(3)
                    kunyomi.code = rs.intForColumnIndex(4)
                    kunyomi.note = rs.stringForColumnIndex(5)
                    
                    outSet.addObject(kunyomi)
                }
            } else {
                println("select failed: \(database.lastErrorMessage())")
            }
            
            return outSet.copy() as NSSet
            
        }
        
    func parseOnyomi(database : FMDatabase, character : String) -> NSSet
        {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let entity = NSEntityDescription.entityForName("Onyomi", inManagedObjectContext: managedContext)!
            
            var outSet : NSMutableSet = NSMutableSet()
            
            if let rs = database.executeQuery("select * from onyomi where kanji='\(character)'", withArgumentsInArray: nil) {
                while rs.next() {
                    
                    let onyomi = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as Onyomi
                    
                    onyomi.kanji = rs.stringForColumnIndex(0)
                    onyomi.reading = rs.stringForColumnIndex(1)
                    onyomi.meaning = rs.stringForColumnIndex(2)
                    onyomi.readingId = rs.intForColumnIndex(3)
                    onyomi.code = rs.intForColumnIndex(4)
                    onyomi.note = rs.stringForColumnIndex(5)
                    
                    outSet.addObject(onyomi)
                }
            } else {
                println("select failed: \(database.lastErrorMessage())")
                //return outSet
            }
            
            return outSet.copy() as NSSet
            
        }
        
        func parseExamples(database : FMDatabase, character : String) -> NSSet
        {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let entity = NSEntityDescription.entityForName("Example", inManagedObjectContext: managedContext)!
            
            var outSet : NSMutableSet = NSMutableSet()
            
            if let rs = database.executeQuery("select * from zlozenia where kanji='\(character)'", withArgumentsInArray: nil) {
                while rs.next() {
                    
                    let example = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as Example
                    
                    example.kanji = rs.stringForColumnIndex(0)
                    example.example = rs.stringForColumnIndex(1)
                    example.reading = rs.stringForColumnIndex(2)
                    example.meaning = rs.stringForColumnIndex(3)
                    example.note = rs.stringForColumnIndex(4)
                    example.exampleId = rs.intForColumnIndex(5)
                    example.code = rs.intForColumnIndex(6)
                    
                    outSet.addObject(example)
                }
            } else {
                println("select failed: \(database.lastErrorMessage())")
            }
            
            return outSet.copy() as NSSet
        }
        
        func parseRadicals(database : FMDatabase, number : Int) -> NSSet
        {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let entity = NSEntityDescription.entityForName("Radical", inManagedObjectContext: managedContext)!
            
            var outSet : NSMutableSet = NSMutableSet()
            
            if let rs = database.executeQuery("select * from pierwiastki where numer=\(number)", withArgumentsInArray: nil) {
                while rs.next() {
                    
                    let radical = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as Radical
                    
                    radical.number = rs.intForColumnIndex(0)
                    radical.radical = rs.stringForColumnIndex(1)
                    radical.name = rs.stringForColumnIndex(2)
                    
                    outSet.addObject(radical)
                }
            } else {
                println("select failed: \(database.lastErrorMessage())")
            }
            
            return outSet.copy() as NSSet
        }
    
    func deleteObjects(description: String)
    {
        //var fetchRequest : NSFetchRequest = NSFetchRequest()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //let entity : NSEntityDescription = NSEntityDescription.entityForName(description, inManagedObjectContext: managedContext)!
        
        let fetchRequest = NSFetchRequest(entityName: description)
        
        var error : NSError?
        let fetchedRequest = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]
        
        //let objects = fetchedRequest as? [NSManagedObjects]
        
        for object in fetchedRequest
        {
        
            managedContext.deleteObject(object)
        }
        

        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func getSelectedObjects(name: String, level: Int, lesson: Int) -> NSArray
    {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: name)
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: managedContext)!
        
        if name == "Character"
        {
            fetchRequest.predicate = NSPredicate(format: "level=\(level) AND lesson=\(lesson)")!
        }
        else
        {
            fetchRequest.predicate = NSPredicate(format: "character.level=\(level) AND character.lesson=\(lesson)")!
        }
        
        let outArray: NSArray = managedContext.executeFetchRequest(fetchRequest, error: nil)!
        return outArray
    }
    
    func getLessonArray(currentLevel : Int) -> [Int]
    {

            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Character")
            let entity = NSEntityDescription.entityForName("Character", inManagedObjectContext: managedContext)!
            //fetchRequest.resultType =
            fetchRequest.propertiesToFetch = ["lesson"]
            fetchRequest.returnsDistinctResults = true
            fetchRequest.predicate = NSPredicate(format: "level=\(currentLevel)")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lesson", ascending: true)]
            fetchRequest.resultType = .DictionaryResultType;
            let outResponse: NSArray = managedContext.executeFetchRequest(fetchRequest, error: nil)!
        
            var outArray = [Int]()
            for object in outResponse
            {
                outArray += [object["lesson"] as Int]
            }

            return outArray
    }
    

        func getLevelArray() -> [Int] {
            
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Character")
            let entity = NSEntityDescription.entityForName("Character", inManagedObjectContext: managedContext)!
            //fetchRequest.resultType =
            fetchRequest.propertiesToFetch = ["level"]
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true)]
            fetchRequest.returnsDistinctResults = true
            fetchRequest.resultType = .DictionaryResultType;
            let outResponse : NSArray = managedContext.executeFetchRequest(fetchRequest, error: nil)!
            var outArray = [Int]()
            for object in outResponse
            {
                 outArray += [object["level"] as Int]
            }
            return outArray
            
    }
    
    func fetchFalseAnswers(object: String, property: String, maxLevel: Int, maxLesson: Int) -> [String]
    {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: object)
        let entity = NSEntityDescription.entityForName(object, inManagedObjectContext: managedContext)!
    
        let predicate = NSPredicate(format: "character.level <= \(maxLevel) AND character.lesson <= \(maxLesson)")
        
        fetchRequest.propertiesToFetch = [property]
        fetchRequest.predicate = predicate
        let outResponse = managedContext.executeFetchRequest(fetchRequest, error: nil)! //as [String]
        let idsArray = generateRandomIdsArray(3, arrayCount: outResponse.count)
        
        var newResponse: [String] = [String]()
        for selectedId in idsArray
        {
            let object = outResponse[selectedId] as NSManagedObject
            newResponse.append(object.valueForKey(property) as String)
        }
        return newResponse
    
    }
    
    
    
    func generateRandomIdsArray(limit: Int, arrayCount: Int) -> [Int]
    {
        var bla = [Int]()
        var count : UInt32 = UInt32(arrayCount)
        while bla.count < limit
        {
            let randomId = Int(arc4random_uniform(count))
            if !(contains(bla, randomId))
            {
                bla.append(randomId)
            }
        }
        
        return bla
    }
}
