//
//  PRDatabaseHelper.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/09.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//


import UIKit
import CoreData

let kPRKanjiJigokuDBUpdateRequest = "http://serwer1456650.home.pl/getUpdateTime.php"
//let kPRKanjiJigokuDBLocation = "http://serwer1456650.home.pl/clientDB.db"
let kPRKanjiJigokuDBRequest = "http://serwer1456650.home.pl/KanjiJigokuDatabase.php?AUTH="


let kPRKanjiJigokuFalseAnswerAmount = 3

private let ObligatoryFlag = "8"

class PRDatabaseHelper
{
    var _timestamp : NSString = NSString()
    
    func syncDatabase() -> Bool
    {
        if(!shouldUpdateDb()) {
            print("database up to date")
            return true
        }
        
        if downloadDbFile() {
            let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
            let path = documentsFolder.stringByAppendingString("/clientDB.db")
            
            let database = FMDatabase(path: path)
            
            if database.open() {
                if parseDb(database) {
                    print("parsed db succesfully")
                    return true
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
                    debugLog("for kanji \(character.kanji) sententces count \(character.sentences!.count)")
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
    
    func getSelectedObjects(name: String, level: Int, lesson: Int) -> NSArray
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: name)        
        if name == "Kanji" {
            
            let sortDescriptor = NSSortDescriptor(key: "kanjiId", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            fetchRequest.predicate = NSPredicate(format: "level=\(level) AND lesson=\(lesson)")
        } else {
            var predicates = [NSPredicate(format: "character.level=\(level)"), NSPredicate(format: "character.lesson=\(lesson)"), NSPredicate(format: "NOT (reading CONTAINS '-')")]
            if !PRStateSingleton.sharedInstance.extraMaterial {
            
                predicates.append(NSPredicate(format: "NOT (code CONTAINS '8')"))
            }
            if name == "Kunyomi" {
            
                predicates.append(NSPredicate(format: "meaning!=''"))
                predicates.append(NSPredicate(format: "meaning!=nil"))
            }
            fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
        }
        let outArray: NSArray = try! managedContext.executeFetchRequest(fetchRequest)
        return outArray
    }
    
    func getLessonArray(currentLevel : Int) -> [Int]
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Kanji")
        fetchRequest.propertiesToFetch = ["lesson"]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.predicate = NSPredicate(format: "level=\(currentLevel)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lesson", ascending: true)]
        fetchRequest.resultType = .DictionaryResultType;
        let outResponse: NSArray = try! managedContext.executeFetchRequest(fetchRequest)
    
        var outArray = [Int]()
        for object in outResponse
        {
            outArray += [object["lesson"] as! Int]
        }
        return outArray
    }
    

        func getLevelArray() -> [Int] {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Kanji")
            fetchRequest.propertiesToFetch = ["level"]
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true)]
            fetchRequest.returnsDistinctResults = true
            fetchRequest.resultType = .DictionaryResultType;
            let outResponse : NSArray = try! managedContext.executeFetchRequest(fetchRequest)
            var outArray = [Int]()
            for object in outResponse {
                 outArray += [object["level"] as! Int]
            }
            return outArray
    }
    
    func fetchFalseAnswers(object: String, property: String, properAnswer: String, partOfSpeechIndex: Int, maxLevel: Int, maxLesson: Int) -> [String]
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: object)
        var predicate : NSPredicate
        if object == "Kanji" {
            predicate = NSPredicate(format: "level <= \(maxLevel) AND lesson <= \(maxLesson)")
        } else {
            // egde case - in case of kuyomi - meaning test you need to make sure that given kunyomi has reading and its the same part of speech as! the correct answer
            if(object == "Kunyomi" && property == "meaning") {
                predicate = NSPredicate(format: "character.level <= \(maxLevel) AND character.lesson <= \(maxLesson) AND ( NOT (reading CONTAINS '-')) AND meaning!='' AND meaning!=nil AND speechPart==\(partOfSpeechIndex)")
            } else {
                predicate = NSPredicate(format: "character.level <= \(maxLevel) AND character.lesson <= \(maxLesson) AND ( NOT (reading CONTAINS '-'))")
            }
        }
        fetchRequest.propertiesToFetch = [property]
        fetchRequest.predicate = predicate
        let outResponse = try! managedContext.executeFetchRequest(fetchRequest) //as! [String]

        var newResponse: [String] = [String]()
        var objectId : Int = generateRandomIdsArray(1, arrayCount: outResponse.count)[0]
        var loopCount = 0
        
        while  newResponse.count < kPRKanjiJigokuFalseAnswerAmount {
            let object = outResponse[objectId] as! NSManagedObject
            let proposedValue : String = object.valueForKey(property) as! String
            if proposedValue != properAnswer && !(newResponse.contains(proposedValue)) {
                newResponse.append(proposedValue)
            }
            if ++loopCount > 100 {
                break
            }
            objectId = generateRandomIdsArray(1, arrayCount: outResponse.count)[0]
        }
        return newResponse
    }

    func generateRandomIdsArray(limit: Int, arrayCount: Int) -> [Int]
    {
        var randomInts = [Int]()
        let count : UInt32 = UInt32(arrayCount)
        while randomInts.count < limit {
            let randomId = Int(arc4random_uniform(count))
            if !(randomInts.contains(randomId)) {
                randomInts.append(randomId)
            }
        }
        return randomInts
    }
    
    // we need to fetch additional example containing given word MINUS:
    // - the ones that are already in kanji related examples
    // -
    func fetchAdditionalExamples(kanji : String) -> [Example]
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!

        let chFetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Kanji")
        chFetchRequest.predicate = NSPredicate(format: "kanji = '\(kanji)'")
        do {
            let characters = try managedContext.executeFetchRequest(chFetchRequest)
            let character = characters[0] as! Kanji
            
            let inList = character.examples!.valueForKeyPath("example") as! NSSet
            let inListArray = inList.allObjects
            
            let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Example")
            fetchRequest.predicate = NSPredicate(format: "example CONTAINS '\(kanji)' AND NOT (example IN %@)", inListArray)
            //  AND example.example NOT IN \(character.examples)
            // create list of examples separated by comma, remove comma after the last element
            let examples = try managedContext.executeFetchRequest(fetchRequest)
            let mutSet = NSMutableSet(array: examples)
            mutSet.minusSet(character.examples! as Set<NSObject>)
            return mutSet.allObjects as! [Example]
            
        } catch {
            return []
        }
    }

    func fetchRelatedKanjis(kanji: Kanji) -> [Kanji]
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Kanji")
        fetchRequest.predicate = NSPredicate(format: "relatedKanji='\(kanji.relatedKanji)' AND (NOT kanji='\(kanji.kanji)')")
        return (try! managedContext.executeFetchRequest(fetchRequest)) as! [Kanji]
    }
    
    
    func fetchObjectsContainingPhrase(object: String, phrase: String) -> [NSManagedObject]
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: object)
        var predicates = [NSPredicate]()
        /*
        we are looking for a match in 3 places:
        1. for kanji we are looking for a kanji-match, onyomi-match, kunyomi match
        2. for examples we are looking for a kanji-match in examples and onyomi match in readings
        3. for sentences we are looking for a kanji-match in sentence and onyomi match in meaning
        */
        var hiraganaPhrase = phrase
        var katakanaPhrase = phrase
        let kanjiPhrase = phrase
        
        if phrase.isRomaji() {
            hiraganaPhrase = PRRomajiKanaConverter().convert(phrase, from: AlphabetType.Romaji, to: AlphabetType.Hiragana)
            katakanaPhrase = PRRomajiKanaConverter().convert(phrase, from: AlphabetType.Romaji, to: AlphabetType.Katakana)
        }
        switch object {
        case "Kanji":
            predicates = [NSPredicate(format: "ANY kunyomis.reading='\(hiraganaPhrase)'"), NSPredicate(format: "ANY onyomis.reading='\(katakanaPhrase)'"),
                NSPredicate(format: "ANY kunyomis.hiraganaReading='\(hiraganaPhrase)'")]
        case "Example":
            predicates = [NSPredicate(format: "reading CONTAINS '\(hiraganaPhrase)'"), NSPredicate(format: "example CONTAINS '\(kanjiPhrase)'")]
        case "Sentence":
            predicates = [NSPredicate(format: "sentence CONTAINS '\(hiraganaPhrase)'"), NSPredicate(format: "meaning CONTAINS '\(phrase)'")]
        default:
            predicates = [NSPredicate]()
        }
        // generate compound predicate based on the specific phrase type
        fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: predicates)
        
        return (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
    }
    
    func fetchSingleKanji(kanji: String) -> Kanji? {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Kanji")
        fetchRequest.predicate = NSPredicate(format: "kanji='\(kanji)'")
        fetchRequest.fetchLimit = 1
        let object = (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        if object.count > 0 {
            return object.first as? Kanji
        } else {
            return nil
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
    // if there is already auth key in the settings, dont display copyright alert
    func readAuthToken(database: FMDatabase) -> (Bool, Bool) {
    
        if let authKey = NSUserDefaults.standardUserDefaults().objectForKey("PRKanjiJigokuAuthKey") {
            if authKey.boolValue {
                return true
            } else {
                requestAuthToken(database)
            }
            
            return true
        } else {
            return false
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
         print("auth query failed")
        }
        return false
    }
}