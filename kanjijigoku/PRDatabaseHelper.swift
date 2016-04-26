//
//  PRDatabaseHelper.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/09.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import CoreData


let kPRKanjiJigokuFalseAnswerAmount = 3



class PRDatabaseHelper
{
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
    
    
    func fetchObjectsContainingPhrase(object: String, var phrase: String) -> [NSManagedObject]
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
            phrase = phrase.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale(localeIdentifier: "pl")).substituteRemainingPolishChars()
        }
        switch object {
        case "Kanji":
            predicates = [NSPredicate(format: "ANY kunyomis.reading='\(hiraganaPhrase)'"), NSPredicate(format: "ANY onyomis.reading='\(katakanaPhrase)'"),
                NSPredicate(format: "ANY kunyomis.hiraganaReading='\(hiraganaPhrase)'")]
        case "Example":
            predicates = [NSPredicate(format: "reading CONTAINS '\(hiraganaPhrase)'"), NSPredicate(format: "example CONTAINS '\(kanjiPhrase)'"), NSPredicate(format: "ascii_meaning CONTAINS[c] '\(phrase)'")]
        case "Sentence":
            predicates = [NSPredicate(format: "sentence CONTAINS '\(hiraganaPhrase)'"), NSPredicate(format: "ascii_meaning CONTAINS[c] '\(phrase)'")]
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

    
    func saveAppSettings() {
    
        let appState = PRStateSingleton.sharedInstance
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Settings", inManagedObjectContext: managedContext)!

        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Settings")
        fetchRequest.fetchLimit = 1
        let objects = (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        
        let settings = (objects.count == 1) ? objects.first as! Settings : NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as! Settings
        
        settings.currentLevel = appState.currentLevel
        settings.currentLesson = appState.currentLesson
        settings.filterLevel = appState.filterLevel
        settings.filterLesson = appState.filterLesson
        settings.filterOn = appState.filterOn
        settings.extraMaterial = appState.extraMaterial
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save")
        }
    }
    
    func loadAppSettings() {
        
        let appState = PRStateSingleton.sharedInstance
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Settings")
        fetchRequest.fetchLimit = 1
        let objects = (try! managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        if objects.count == 1 {
        
            let settings = objects.first as! Settings
            
            appState.currentLevel = settings.currentLevel!.integerValue
            appState.currentLesson = settings.currentLesson!.integerValue
            appState.filterLevel = settings.filterLevel!.integerValue
            appState.filterLesson = settings.filterLesson!.integerValue
            appState.filterOn = settings.filterOn!.boolValue
            appState.extraMaterial = settings.extraMaterial!.boolValue
        }
    }
}