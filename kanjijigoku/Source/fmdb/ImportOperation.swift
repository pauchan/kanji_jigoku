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

class ImportOperation: Operation {
    
    var _timestamp: NSString = NSString()
    var updateMessage: String?
    let remoteImport: Bool
    
    override func main()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        managedContext.performAndWait { () -> Void in
            
            self.importDB()
        }
    }
    
    init(remoteImport: Bool) {
        self.remoteImport = remoteImport
        super.init()
    }
    
    func importDB() {
        let path = Bundle.main.path(forResource: "clientDB", ofType: "db")
        let database = FMDatabase(path: path)
        
        guard (database?.open())! else { fatalError("Unable to open database") }
        
        // TODO: parse should not fail, add guard (log?) here
        if parseDb(database!) {
            self.updateMessage = updateAlertMessage(readAuthToken(), requestedToken: requestAuthToken(database!))
        } else {
            print("db parse failed")
        }
        database?.close()
    }
    
    func downloadFullAccessDb() -> Bool {
        
        let stringURL : String = kPRKanjiJigokuDBLocation
        
        if let url : URL = URL(string: stringURL) {
            if let urlData : Data = try? Data(contentsOf: url) {
                let paths : NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
                if let documentsDirectory = (paths[0] as? String) {
                    let filePath : String = documentsDirectory + "/clientDB.db"
                    return  ((try? urlData.write(to: URL(fileURLWithPath: filePath), options: [.atomic])) != nil)
                }
            }
        }
        return false
    }
    
    func downloadDbFile() -> Bool
    {
        let stringURL : String = String("\(kPRKanjiJigokuDBRequest)\(UserDefaults.standard.integer(forKey: "PRKanjiJigokuAuthKey"))")
        
        if let url : URL = URL(string: stringURL) {
            if let urlData : Data = try? Data(contentsOf: url) {
                let paths : NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
                if let documentsDirectory = (paths[0] as? String) {
                    let filePath : String = documentsDirectory + "/clientDB.db"
                    return  ((try? urlData.write(to: URL(fileURLWithPath: filePath), options: [.atomic])) != nil)
                }
            }
        }
        return false
    }
    
    func shouldUpdateDb() -> Bool {
        
        if let appDbUpdate : NSString = UserDefaults.standard.object(forKey: "PRKanjiJigokuDbUpdate") as? String as NSString? {
            
            if let url : URL = URL(string: kPRKanjiJigokuDBUpdateRequest) {
                if let urlData : Data = try? Data(contentsOf: url)
                {
                    if let timestamp = NSString(data: urlData, encoding: String.Encoding.utf8.rawValue)
                    {
                        if(appDbUpdate.isEqual(to: timestamp as String))
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
    
    func parseDb(_ database : FMDatabase) -> Bool
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
        
        UserDefaults.standard.set(_timestamp, forKey: "PRKanjiJigokuDbUpdate")
        print("Update successful")
        
        return true
    }
    
    func parseKanjis(_ database : FMDatabase) -> Bool
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "Kanji", in: managedContext)!
        
        if let rs = database.executeQuery("select * from znaki", withArgumentsIn: nil) {
            while rs.next() {
                
                if !self.shouldSaveEntity(String(rs.int(forColumnIndex: 14))) {
                    continue
                }
                
                let character = NSManagedObject(entity: entity, insertInto: managedContext) as! Kanji
                
                character.kanji = rs.string(forColumnIndex: 0)
                character.alternativeKanji = rs.string(forColumnIndex: 1)
                character.strokeCount = rs.int(forColumnIndex: 2)
                character.radical = rs.int(forColumnIndex: 3)
                character.alternativeRadical = rs.int(forColumnIndex: 4)
                character.meaning = rs.string(forColumnIndex: 5)
                // skipping columns with index 6 (pinyin) and index 7 (nonori)
                character.note = rs.string(forColumnIndex: 8)
                character.relatedKanji = rs.string(forColumnIndex: 9)
                character.lesson = rs.int(forColumnIndex: 10)
                character.level = rs.int(forColumnIndex: 11)
                character.kanjiId = rs.int(forColumnIndex: 12)
                // skipping column 13 id_sql
                character.code = String(rs.int(forColumnIndex: 14))
                
                let (kunyomiSet, exampleSet) = parseKunyomi(database, character: character.kanji!)
                
                character.kunyomis = kunyomiSet
                character.onyomis = parseOnyomi(database, character: character.kanji!)
                let mutExampleSet = parseExamples(database, character: character.kanji!)
                character.examples = mutExampleSet.addingObjects(from: exampleSet as Set<NSObject>) as NSSet?
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
    
    func parseSentences(_ database : FMDatabase, character : String) -> NSSet
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "Sentence", in: managedContext)!
        
        let outSet : NSMutableSet = NSMutableSet()
        if let rs = database.executeQuery("select * from zdania where kanji='\(character)'", withArgumentsIn: nil) {
            while rs.next() {
                
                if !self.shouldSaveEntity(String(rs.int(forColumnIndex: 4))) {
                    continue
                }
                
                let sentence = NSManagedObject(entity: entity, insertInto: managedContext) as! Sentence
                
                sentence.kanji = rs.string(forColumnIndex: 0)
                sentence.example = rs.string(forColumnIndex: 1)
                sentence.sentence = rs.string(forColumnIndex: 2)
                sentence.meaning = rs.string(forColumnIndex: 3)
                sentence.ascii_meaning = sentence.meaning!.folding(options: .diacriticInsensitive, locale: Locale.current)
                sentence.code = String(rs.int(forColumnIndex: 4))
                sentence.sentenceId = rs.int(forColumnIndex: 5)
                
                outSet.add(sentence)
                //count++
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
        }
        return outSet.copy() as! NSSet
        
    }
    
    func parseKunyomi(_ database : FMDatabase, character : String) -> (NSSet, NSSet)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "Kunyomi", in: managedContext)!
        
        let exampleEntity = NSEntityDescription.entity(forEntityName: "Example", in: managedContext)!
        
        let kunyomiSet : NSMutableSet = NSMutableSet()
        let examplesSet : NSMutableSet = NSMutableSet()
        
        if let rs = database.executeQuery("select * from kunyomi where kanji='\(character)'", withArgumentsIn: nil) {
            while rs.next() {
                
                if !self.shouldSaveEntity(String(rs.int(forColumnIndex: 4))) {
                    continue
                }
                let kunyomi = NSManagedObject(entity: entity, insertInto: managedContext) as! Kunyomi
                
                kunyomi.kanji = rs.string(forColumnIndex: 0)
                kunyomi.reading = rs.string(forColumnIndex: 1)
                kunyomi.meaning = rs.string(forColumnIndex: 2)
                kunyomi.readingId = rs.int(forColumnIndex: 3)
                kunyomi.code = String(rs.int(forColumnIndex: 4))
                kunyomi.note = rs.string(forColumnIndex: 5)
                kunyomi.hiraganaReading = kunyomi.reading?.plainHiragana()
                
                kunyomiSet.add(kunyomi)
                
                // for kunyomis we also are creating example object (provided it has non-empty meaning)
                if (kunyomi.meaning == "") {
                    continue
                }
                
                let example = NSManagedObject(entity: exampleEntity, insertInto: managedContext) as! Example
                example.kanji = rs.string(forColumnIndex: 0)
                example.reading = rs.string(forColumnIndex: 1).plainHiragana()
                example.example = rs.string(forColumnIndex: 1).kanjiWithOkurigana(rs.string(forColumnIndex: 0))
                example.meaning = rs.string(forColumnIndex: 2)
                example.ascii_meaning = example.meaning!.folding(options: .diacriticInsensitive, locale: Locale(identifier: "pl")).substituteRemainingPolishChars()
                example.code = "0"
                example.note = rs.string(forColumnIndex: 5)
                
                examplesSet.add(example)
                
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
        }
        return (kunyomiSet.copy() as! NSSet,examplesSet.copy() as! NSSet)
    }
    
    func parseOnyomi(_ database : FMDatabase, character : String) -> NSSet
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "Onyomi", in: managedContext)!
        
        let outSet : NSMutableSet = NSMutableSet()
        
        if let rs = database.executeQuery("select * from onyomi where kanji='\(character)'", withArgumentsIn: nil) {
            while rs.next() {
                if !self.shouldSaveEntity(String(rs.int(forColumnIndex: 4))) {
                    continue
                }
                
                let onyomi = NSManagedObject(entity: entity, insertInto: managedContext) as! Onyomi
                
                onyomi.kanji = rs.string(forColumnIndex: 0)
                onyomi.reading = rs.string(forColumnIndex: 1)
                onyomi.meaning = rs.string(forColumnIndex: 2)
                onyomi.readingId = rs.int(forColumnIndex: 3)
                onyomi.code = String(rs.int(forColumnIndex: 4))
                onyomi.note = String(rs.int(forColumnIndex: 5))
                
                outSet.add(onyomi)
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
            //return outSet
        }
        return outSet.copy() as! NSSet
    }
    
    func parseExamples(_ database : FMDatabase, character : String) -> NSSet
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "Example", in: managedContext)!
        
        let outSet : NSMutableSet = NSMutableSet()
        
        if let rs = database.executeQuery("select * from zlozenia where kanji='\(character)'", withArgumentsIn: nil) {
            while rs.next() {
                if !self.shouldSaveEntity(String(rs.int(forColumnIndex: 6))) {
                    continue
                }
                
                let example = NSManagedObject(entity: entity, insertInto: managedContext) as! Example
                
                example.kanji = rs.string(forColumnIndex: 0)
                example.example = rs.string(forColumnIndex: 1)
                example.reading = rs.string(forColumnIndex: 2)
                example.meaning = rs.string(forColumnIndex: 3)
                example.note = rs.string(forColumnIndex: 4)
                example.exampleId = rs.int(forColumnIndex: 5)
                example.code = String(rs.int(forColumnIndex: 6))
                
                outSet.add(example)
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
        }
        
        return outSet.copy() as! NSSet
    }
    
    func parseRadicals(_ database : FMDatabase, number : Int) -> NSSet
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "Radical", in: managedContext)!
        
        let outSet : NSMutableSet = NSMutableSet()
        
        if let rs = database.executeQuery("select * from pierwiastki where numer=\(number)", withArgumentsIn: nil) {
            while rs.next() {
                
                let radical = NSManagedObject(entity: entity, insertInto: managedContext) as! Radical
                
                radical.number = rs.int(forColumnIndex: 0)
                radical.radical = rs.string(forColumnIndex: 1)
                radical.name = rs.string(forColumnIndex: 2)
                
                outSet.add(radical)
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
        }
        
        return outSet.copy() as! NSSet
    }
    
    func deleteObjects(_ description: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: description)
        let fetchedRequest = (try! managedContext.fetch(fetchRequest)) as! [NSManagedObject]
        for object in fetchedRequest {
            managedContext.delete(object)
        }
        do {
            try managedContext.save()
        } catch {
            print("Could not save")
        }
    }
    
    // if obli code is 7 or 9, do not save the entity in db
    func shouldSaveEntity(_ text: String) -> Bool {
        
        if text.range(of: "7") != nil || text.range(of: "9") != nil  {
            return false
        } else {
            return true
        }
    }
    
    func updateAlertMessage(_ readToken: Bool?, requestedToken: Bool) -> String? {
        
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
        if let object = UserDefaults.standard.object(forKey: "PRKanjiJigokuAuthKey") {
            return (object as AnyObject).boolValue
        } else {
            return nil
        }
    }
    
    func requestAuthToken(_ database: FMDatabase) -> Bool {
        if let rs = database.executeQuery("SELECT auth FROM update_time", withArgumentsIn: nil) {
            while rs.next() {
                let authFlag = rs.bool(forColumnIndex: 0)
                if authFlag {
                    UserDefaults.standard.set(authFlag, forKey: "PRKanjiJigokuAuthKey")
                    UserDefaults.standard.synchronize()
                    return authFlag
                }
            }
        } else {
            debugLog("auth query failed")
        }
        return false
    }

}
