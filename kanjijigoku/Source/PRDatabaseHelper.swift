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
    func getSelectedObjects(_ name: String, level: Int, lesson: Int) -> NSArray
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        if name == "Kanji" {
            let sortDescriptor = NSSortDescriptor(key: "kanjiId", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            fetchRequest.predicate = NSPredicate(format: "level=\(level) AND lesson=\(lesson)")
        } else {
            let fetchRequest : NSFetchRequest<Kanji> = NSFetchRequest(entityName: name)
            var predicates = [NSPredicate(format: "character.level=\(level)"), NSPredicate(format: "character.lesson=\(lesson)"), NSPredicate(format: "NOT (reading CONTAINS '-')")]
            if !PRStateSingleton.sharedInstance.extraMaterial {
            
                predicates.append(NSPredicate(format: "NOT (code CONTAINS '8')"))
            }
            if name == "Kunyomi" {
            
                predicates.append(NSPredicate(format: "meaning!=''"))
                predicates.append(NSPredicate(format: "meaning!=nil"))
            }
            fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        }
        let outArray: NSArray = try! managedContext.fetch(fetchRequest) as NSArray
        return outArray
    }
    
    func getLessonArray(_ currentLevel : Int) -> [Int]
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Kanji")
        fetchRequest.propertiesToFetch = ["lesson"]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.predicate = NSPredicate(format: "level=\(currentLevel)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lesson", ascending: true)]
        fetchRequest.resultType = .dictionaryResultType
        let outResponse = try? managedContext.fetch(fetchRequest)
        if let res = outResponse as? [[String : Int]] {
            return res.map { $0.values.first! }
        } else {
            return []
        }
    }
    

        func getLevelArray() -> [Int] {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Kanji")
            fetchRequest.propertiesToFetch = ["level"]
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true)]
            fetchRequest.returnsDistinctResults = true
            fetchRequest.resultType = .dictionaryResultType
            let outResponse = try? managedContext.fetch(fetchRequest)
            
            if let res = outResponse as? [[String : Int]] {
                return res.map { $0.values.first! }
            } else {
                return []
            }
    }
    
    func fetchFalseAnswers(_ object: String, property: String, properAnswer: String, partOfSpeechIndex: Int, maxLevel: Int, maxLesson: Int) -> [String]
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: object)
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
        let outResponse = try! managedContext.fetch(fetchRequest) //as! [String]

        var newResponse: [String] = [String]()
        var objectId : Int = generateRandomIdsArray(1, arrayCount: outResponse.count)[0]
        var loopCount = 0
        
        while  newResponse.count < kPRKanjiJigokuFalseAnswerAmount {
            let object = outResponse[objectId] as! NSManagedObject
            let proposedValue : String = object.value(forKey: property) as! String
            if proposedValue != properAnswer && !(newResponse.contains(proposedValue)) {
                newResponse.append(proposedValue)
            }
            loopCount += 1
            if loopCount > 100 {
                break
            }
            objectId = generateRandomIdsArray(1, arrayCount: outResponse.count)[0]
        }
        return newResponse
    }

    func generateRandomIdsArray(_ limit: Int, arrayCount: Int) -> [Int]
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
    func fetchAdditionalExamples(_ kanji : String) -> [Example]
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!

        let chFetchRequest = NSFetchRequest<Kanji>(entityName: "Kanji")
        chFetchRequest.predicate = NSPredicate(format: "kanji = '\(kanji)'")
        do {
            let characters = try managedContext.fetch(chFetchRequest)
            let character = characters[0]
            
            let inList = character.examples!.value(forKeyPath: "example") as! NSSet
            let inListArray = inList.allObjects
            
            let fetchRequest :NSFetchRequest<Example> = NSFetchRequest(entityName: "Example")
            fetchRequest.predicate = NSPredicate(format: "example CONTAINS '\(kanji)' AND NOT (example IN %@)", inListArray)
            //  AND example.example NOT IN \(character.examples)
            // create list of examples separated by comma, remove comma after the last element
            let examples = try managedContext.fetch(fetchRequest)
            let mutSet = NSMutableSet(array: examples)
            mutSet.minus(character.examples! as Set<NSObject>)
            return mutSet.allObjects as! [Example]
            
        } catch {
            return []
        }
    }

    func fetchRelatedKanjis(_ kanji: Kanji) -> [Kanji]
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest :NSFetchRequest<Kanji> = NSFetchRequest(entityName: "Kanji")
        fetchRequest.predicate = NSPredicate(format: "relatedKanji='\(kanji.relatedKanji)' AND (NOT kanji='\(kanji.kanji)')")
        return (try! managedContext.fetch(fetchRequest))
    }
    
    
    func fetchObjectsContainingPhrase(_ object: String, phrase: String) -> [NSManagedObject]
    {
        var phrase = phrase
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest :NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: object)
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
            hiraganaPhrase = PRRomajiKanaConverter().convert(phrase, from: AlphabetType.romaji, to: AlphabetType.hiragana)
            katakanaPhrase = PRRomajiKanaConverter().convert(phrase, from: AlphabetType.romaji, to: AlphabetType.katakana)
            phrase = phrase.folding(options: .diacriticInsensitive, locale: Locale(identifier: "pl")).substituteRemainingPolishChars()
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
        fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: predicates)
        
        return (try! managedContext.fetch(fetchRequest)) as! [NSManagedObject]
    }
    
    func fetchSingleKanji(_ kanji: String) -> Kanji? {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest :NSFetchRequest<Kanji> = NSFetchRequest(entityName: "Kanji")
        fetchRequest.predicate = NSPredicate(format: "kanji='\(kanji)'")
        fetchRequest.fetchLimit = 1
        let objects = (try! managedContext.fetch(fetchRequest))
        return objects.count > 0 ? objects.first : nil
    }

    
    func saveAppSettings() {
    
        let appState = PRStateSingleton.sharedInstance
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "Settings", in: managedContext)!

        let fetchRequest :NSFetchRequest<Settings> = NSFetchRequest(entityName: "Settings")
        fetchRequest.fetchLimit = 1
        let objects = (try! managedContext.fetch(fetchRequest))
        
        
        let settings = (objects.count == 1) ? objects.first! : NSManagedObject(entity: entity, insertInto: managedContext) as! Settings
        
        settings.currentLevel = appState.currentLevel as NSNumber?
        settings.currentLesson = appState.currentLesson as NSNumber?
        settings.filterLevel = appState.filterLevel as NSNumber?
        settings.filterLesson = appState.filterLesson as NSNumber?
        settings.filterOn = appState.filterOn as NSNumber?
        settings.extraMaterial = appState.extraMaterial as NSNumber?
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save")
        }
    }
    
    func loadAppSettings() {
        
        let appState = PRStateSingleton.sharedInstance
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest :NSFetchRequest<Settings> = NSFetchRequest(entityName: "Settings")
        fetchRequest.fetchLimit = 1
        let objects = (try! managedContext.fetch(fetchRequest))
        
        if objects.count == 1 {
        
            if let settings = objects.first {
                appState.currentLevel = settings.currentLevel!.intValue
                appState.currentLesson = settings.currentLesson!.intValue
                appState.filterLevel = settings.filterLevel!.intValue
                appState.filterLesson = settings.filterLesson!.intValue
                appState.filterOn = settings.filterOn!.boolValue
                appState.extraMaterial = settings.extraMaterial!.boolValue
                appState.levelArray = PRDatabaseHelper().getLevelArray()
                appState.lessonArray = PRDatabaseHelper().getLessonArray(appState.currentLevel)
            }
        }
    }
}
