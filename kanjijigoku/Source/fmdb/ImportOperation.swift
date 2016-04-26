//
//  ImportOperation.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 4/26/16.
//  Copyright © 2016 Pawel Rusin. All rights reserved.
//

import UIKit
import CoreData
import FMDB

let kPRKanjiJigokuDBUpdateRequest = "http://serwer1456650.home.pl/getUpdateTime.php"
let kPRKanjiJigokuDBLocation = "http://serwer1456650.home.pl/clientDB.db"
let kPRKanjiJigokuDBRequest = "http://serwer1456650.home.pl/KanjiJigokuDatabase.php?AUTH="

let kFullAccessMessage = "Posiadasz pełny dostęp do bazy."
let kLimitedAccessMessage = "Posiadasz ograniczony dostęp do bazy, ponieważ nie jesteś zalogowany do sieci Uniwersytetu Jagiellońskiego. Zaloguj urządzenie do sieci uniwersyteckiej i zaktualizuj bazę. Kolejne aktualizacje już nie wymagają połączenia z siecią UJ."

private let ObligatoryFlag = "8"

class ImportOperation: NSOperation {
    
    var _timestamp : NSString = NSString()
    var updateMessage:String?
    
    override func main()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        managedContext.performBlockAndWait { () -> Void in
            
            self.importDB()
        }
    }
    
    func importDB() {
        
        if(!shouldUpdateDb()) {
            debugLog("database up to date")
            return
        }
        //if downloadFullAccessDb() {
        if downloadDbFile() {
            let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let path = documentsFolder.stringByAppendingString("/clientDB.db")
            
            let database = FMDatabase(path: path)
            
            if database.open() {
                if parseDb(database) {
                    debugLog("parsed db succesfully")
                    self.updateMessage = updateAlertMessage(readAuthToken(), requestedToken: requestAuthToken(database))
                    return
                } else {
                    print("db parse failed")
                }
                database.close()
            } else {
                print("Unable to open database")
            }
        } else {
            print("Download db file failed")
        }
        return
    
    }
    
    func downloadFullAccessDb() -> Bool {
        
        let stringURL : String = kPRKanjiJigokuDBLocation
        
        if let url : NSURL = NSURL(string: stringURL) {
            if let urlData : NSData = NSData(contentsOfURL: url) {
                let paths : NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                if let documentsDirectory = (paths[0] as? String) {
                    let filePath : String = documentsDirectory.stringByAppendingString("/clientDB.db")
                    return  urlData.writeToFile(filePath, atomically: true)
                }
            }
        }
        return false
    }
    
    func downloadDbFile() -> Bool
    {
        let stringURL : String = String("\(kPRKanjiJigokuDBRequest)\(NSUserDefaults.standardUserDefaults().integerForKey("PRKanjiJigokuAuthKey"))")
        
        if let url : NSURL = NSURL(string: stringURL) {
            if let urlData : NSData = NSData(contentsOfURL: url) {
                let paths : NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                if let documentsDirectory = (paths[0] as? String) {
                    let filePath : String = documentsDirectory.stringByAppendingString("/clientDB.db")
                    return  urlData.writeToFile(filePath, atomically: true)
                }
            }
        }
        return false
    }
    
    func shouldUpdateDb() -> Bool
    {
        
        if let appDbUpdate : NSString = NSUserDefaults.standardUserDefaults().objectForKey("PRKanjiJigokuDbUpdate") as? String {
            
            if let url : NSURL = NSURL(string: kPRKanjiJigokuDBUpdateRequest) {
                if let urlData : NSData = NSData(contentsOfURL: url)
                {
                    if let timestamp = NSString(data: urlData, encoding: NSUTF8StringEncoding)
                    {
                        if(appDbUpdate.isEqualToString(timestamp as String))
                        {
                            //_timestamp = timestamp
                            print("there is no new version of db")
                            return false
                        } else {
                            _timestamp = timestamp
                            print("new version - updating")
                            return true
                        }
                    }
                }
            }
            // there was some data error or connectivity errror. We still ha
            print("connetivity error. Using old version of db")
            return false
        } else {
            // there is no user default for timestamp so new db needs to be created
            return true
        }
    }
    
    func parseDb(database : FMDatabase) -> Bool
    {
        deleteObjects("Kanji")
        deleteObjects("Kunyomi")
        deleteObjects("Onyomi")
        deleteObjects("Sentence")
        deleteObjects("Example")
        deleteObjects("Radical")
        deleteObjects("Settings")
        
        if !parseKanjis(database) {
            print("failed to parse characters")
            return false
        }
        
        NSUserDefaults.standardUserDefaults().setObject(_timestamp, forKey: "PRKanjiJigokuDbUpdate")
        print("Update successful")
        
        return true
    }
    
    func parseKanjis(database : FMDatabase) -> Bool
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Kanji", inManagedObjectContext: managedContext)!
        
        if let rs = database.executeQuery("select * from znaki", withArgumentsInArray: nil) {
            while rs.next() {
                
                if !self.shouldSaveEntity(String(rs.intForColumnIndex(14))) {
                    continue
                }
                
                let character = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as! Kanji
                
                character.kanji = rs.stringForColumnIndex(0)
                character.alternativeKanji = rs.stringForColumnIndex(1)
                character.strokeCount = rs.intForColumnIndex(2)
                character.radical = rs.intForColumnIndex(3)
                character.alternativeRadical = rs.intForColumnIndex(4)
                character.meaning = rs.stringForColumnIndex(5)
                // skipping columns with index 6 (pinyin) and index 7 (nonori)
                character.note = rs.stringForColumnIndex(8)
                character.relatedKanji = rs.stringForColumnIndex(9)
                character.lesson = rs.intForColumnIndex(10)
                character.level = rs.intForColumnIndex(11)
                character.kanjiId = rs.intForColumnIndex(12)
                // skipping column 13 id_sql
                character.code = String(rs.intForColumnIndex(14))
                
                let (kunyomiSet, exampleSet) = parseKunyomi(database, character: character.kanji!)
                
                character.kunyomis = kunyomiSet
                character.onyomis = parseOnyomi(database, character: character.kanji!)
                let mutExampleSet = parseExamples(database, character: character.kanji!)
                character.examples = mutExampleSet.setByAddingObjectsFromSet(exampleSet as Set<NSObject>)
                character.sentences = parseSentences(database, character: character.kanji!)
                character.radicals = parseRadicals(database, number: Int(character.radical))
                
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
            return false
        }
        do {
            try managedContext.save()
        } catch {
            print("Could not save")
            return false
        }
        return true
    }
    
    func parseSentences(database : FMDatabase, character : String) -> NSSet
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Sentence", inManagedObjectContext: managedContext)!
        
        let outSet : NSMutableSet = NSMutableSet()
        if let rs = database.executeQuery("select * from zdania where kanji='\(character)'", withArgumentsInArray: nil) {
            while rs.next() {
                
                if !self.shouldSaveEntity(String(rs.intForColumnIndex(4))) {
                    continue
                }
                
                let sentence = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as! Sentence
                
                sentence.kanji = rs.stringForColumnIndex(0)
                sentence.example = rs.stringForColumnIndex(1)
                sentence.sentence = rs.stringForColumnIndex(2)
                sentence.meaning = rs.stringForColumnIndex(3)
                sentence.ascii_meaning = sentence.meaning!.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
                sentence.code = String(rs.intForColumnIndex(4))
                sentence.sentenceId = rs.intForColumnIndex(5)
                
                outSet.addObject(sentence)
                //count++
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
        }
        return outSet.copy() as! NSSet
        
    }
    
    func parseKunyomi(database : FMDatabase, character : String) -> (NSSet, NSSet)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Kunyomi", inManagedObjectContext: managedContext)!
        
        let exampleEntity = NSEntityDescription.entityForName("Example", inManagedObjectContext: managedContext)!
        
        let kunyomiSet : NSMutableSet = NSMutableSet()
        let examplesSet : NSMutableSet = NSMutableSet()
        
        if let rs = database.executeQuery("select * from kunyomi where kanji='\(character)'", withArgumentsInArray: nil) {
            while rs.next() {
                
                if !self.shouldSaveEntity(String(rs.intForColumnIndex(4))) {
                    continue
                }
                let kunyomi = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as! Kunyomi
                
                kunyomi.kanji = rs.stringForColumnIndex(0)
                kunyomi.reading = rs.stringForColumnIndex(1)
                kunyomi.meaning = rs.stringForColumnIndex(2)
                kunyomi.readingId = rs.intForColumnIndex(3)
                kunyomi.code = String(rs.intForColumnIndex(4))
                kunyomi.note = rs.stringForColumnIndex(5)
                kunyomi.hiraganaReading = kunyomi.reading?.plainHiragana()
                
                kunyomiSet.addObject(kunyomi)
                
                // for kunyomis we also are creating example object (provided it has non-empty meaning)
                if (kunyomi.meaning == "") {
                    continue
                }
                
                let example = NSManagedObject(entity: exampleEntity, insertIntoManagedObjectContext: managedContext) as! Example
                example.kanji = rs.stringForColumnIndex(0)
                example.reading = rs.stringForColumnIndex(1).plainHiragana()
                example.example = rs.stringForColumnIndex(1).kanjiWithOkurigana(rs.stringForColumnIndex(0))
                example.meaning = rs.stringForColumnIndex(2)
                example.ascii_meaning = example.meaning!.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale(localeIdentifier: "pl")).substituteRemainingPolishChars()
                example.code = "0"
                example.note = rs.stringForColumnIndex(5)
                
                examplesSet.addObject(example)
                
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
        }
        return (kunyomiSet.copy() as! NSSet,examplesSet.copy() as! NSSet)
    }
    
    func parseOnyomi(database : FMDatabase, character : String) -> NSSet
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Onyomi", inManagedObjectContext: managedContext)!
        
        let outSet : NSMutableSet = NSMutableSet()
        
        if let rs = database.executeQuery("select * from onyomi where kanji='\(character)'", withArgumentsInArray: nil) {
            while rs.next() {
                if !self.shouldSaveEntity(String(rs.intForColumnIndex(4))) {
                    continue
                }
                
                let onyomi = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as! Onyomi
                
                onyomi.kanji = rs.stringForColumnIndex(0)
                onyomi.reading = rs.stringForColumnIndex(1)
                onyomi.meaning = rs.stringForColumnIndex(2)
                onyomi.readingId = rs.intForColumnIndex(3)
                onyomi.code = String(rs.intForColumnIndex(4))
                onyomi.note = String(rs.intForColumnIndex(5))
                
                outSet.addObject(onyomi)
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
            //return outSet
        }
        return outSet.copy() as! NSSet
    }
    
    func parseExamples(database : FMDatabase, character : String) -> NSSet
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Example", inManagedObjectContext: managedContext)!
        
        let outSet : NSMutableSet = NSMutableSet()
        
        if let rs = database.executeQuery("select * from zlozenia where kanji='\(character)'", withArgumentsInArray: nil) {
            while rs.next() {
                if !self.shouldSaveEntity(String(rs.intForColumnIndex(6))) {
                    continue
                }
                
                let example = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as! Example
                
                example.kanji = rs.stringForColumnIndex(0)
                example.example = rs.stringForColumnIndex(1)
                example.reading = rs.stringForColumnIndex(2)
                example.meaning = rs.stringForColumnIndex(3)
                example.note = rs.stringForColumnIndex(4)
                example.exampleId = rs.intForColumnIndex(5)
                example.code = String(rs.intForColumnIndex(6))
                
                outSet.addObject(example)
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
        }
        
        return outSet.copy() as! NSSet
    }
    
    func parseRadicals(database : FMDatabase, number : Int) -> NSSet
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Radical", inManagedObjectContext: managedContext)!
        
        let outSet : NSMutableSet = NSMutableSet()
        
        if let rs = database.executeQuery("select * from pierwiastki where numer=\(number)", withArgumentsInArray: nil) {
            while rs.next() {
                
                let radical = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as! Radical
                
                radical.number = rs.intForColumnIndex(0)
                radical.radical = rs.stringForColumnIndex(1)
                radical.name = rs.stringForColumnIndex(2)
                
                outSet.addObject(radical)
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
        }
        
        return outSet.copy() as! NSSet
    }
    
    func deleteObjects(description: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: description)
        let fetchedRequest = (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        for object in fetchedRequest {
            managedContext.deleteObject(object)
        }
        do {
            try managedContext.save()
        } catch {
            print("Could not save")
        }
    }
    
    // if obli code is 7 or 9, do not save the entity in db
    func shouldSaveEntity(text: String) -> Bool {
        
        if text.rangeOfString("7") != nil || text.rangeOfString("9") != nil  {
            return false
        } else {
            return true
        }
    }
    
    func updateAlertMessage(readToken: Bool?, requestedToken: Bool) -> String? {
        
        if readToken != nil {
            if !readToken! && requestedToken {
                return kFullAccessMessage
            }
        } else {
            return (requestedToken) ? kFullAccessMessage : kLimitedAccessMessage
        }
        return nil
    }
    
    func readAuthToken() -> Bool? {
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("PRKanjiJigokuAuthKey") {
            return object.boolValue
        } else {
            return nil
        }
    }
    
    func requestAuthToken(database: FMDatabase) -> Bool {
        if let rs = database.executeQuery("SELECT auth FROM update_time", withArgumentsInArray: nil) {
            while rs.next() {
                let authFlag = rs.boolForColumnIndex(0)
                if authFlag {
                    NSUserDefaults.standardUserDefaults().setBool(authFlag, forKey: "PRKanjiJigokuAuthKey")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    return authFlag
                }
            }
        } else {
            debugLog("auth query failed")
        }
        return false
    }

}
