//
//  PRTestsViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit
import CoreData

enum TestOptions: Int {

    case kKanjiOnyomiTest = 0, kKanjiKunyomiTest, kOnyomiKanjiTest, kKunyomiKanjiTest, kKanjiMeaningTest, kKunyomiMeaningTest, kExampleMeaningTest, kMeaningExampleTest
}

class PRTestMenuViewController : UITableViewController
{
    var _tableItems : NSArray!
    var _headerCoordinator : PRHeaderCoordinator!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("testPairing", ofType: "plist") {
            self._tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }

        self.tableView.keyboardDismissMode = .Interactive
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "prKanjiJigokuRightBarItemShowSettings:")
        self.navigationItem.title = "Kanji Jigoku"
        // Do any additional setup after loading the view, typically from a nib.
        let nib : UINib = UINib(nibName: "PRHeaderViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PRHeaderViewCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRFlashcardCell")
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRHeaderViewCell", forIndexPath: indexPath) as PRHeaderViewCell
            _headerCoordinator = PRHeaderCoordinator(headerCell: cell)
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRFlashcardCell", forIndexPath: indexPath) as UITableViewCell
            let testDict = _tableItems[indexPath.row] as [String: String]
            cell.textLabel?.text = testDict["label"]
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section != 0
        {
    
                var vc = PRTestViewController(nibName: "PRTestViewController", bundle: nil)
                let testDict : [String: String] = _tableItems[indexPath.row] as [String: String]
                vc.questions = generateTest(testDict)
                vc.descriptionText = testDict["label"]!
                navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0)
        {
            return 90.0
        }
        else
        {
            return 45.0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return 1
        }
        else
        {
            return _tableItems.count
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func generateFlashcardsArrayForReadings(characters: [Character], option: Int) -> [Flashcard]
    {
        
        var returnArray : [Flashcard] = [Flashcard]()
        for kanjiCharacter in characters
        {
            if(option == kOnyomiOption){
                returnArray.append(Flashcard(text: kanjiCharacter.kanji, reading: kanjiCharacter.generateReadingString(kanjiCharacter.onyomis), meaning: kanjiCharacter.meaning))
            }
            else // option == kKunyomiOption
            {
                returnArray.append(Flashcard(text: kanjiCharacter.kanji, reading: kanjiCharacter.generateReadingString(kanjiCharacter.kunyomis), meaning: kanjiCharacter.meaning))
            }
        }
        return returnArray
    }

    
    func generateTest(testDict: [String:String]) -> [Question]
    {
        // 1. fetch all the objects for the given lesson
        var wideArray = PRDatabaseHelper().getSelectedObjects(testDict["questionObject"]!, level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson)
        
        // 2. randomly select 10 of them
        let idsArray = PRDatabaseHelper().generateRandomIdsArray(10, arrayCount: wideArray.count)
        
        var newResponse: [Question] = [Question]()
        for selectedId in idsArray
        {
            let object: AnyObject = wideArray[selectedId]
            let questionString : String = object.valueForKey(testDict["questionProperty"]!) as String
            
            // 3. for each assign 3 wrong answer for each type
            let falseAnswers = PRDatabaseHelper().fetchFalseAnswers(testDict["questionObject"]!, property: testDict["answerProperty"]!, maxLevel: PRStateSingleton.sharedInstance.currentLevel, maxLesson: PRStateSingleton.sharedInstance.currentLesson)
    
            let properAnswer = object.valueForKey(testDict["answerProperty"]!) as String
            let meaning = object.valueForKey("meaning") as String
            let question = Question(question: questionString, correctOption: properAnswer,  falseOptions: falseAnswers, meaning: meaning)
            newResponse.append(question)
            //newResponse.append(object.valueForKey(property) as String)
        }
        return newResponse
        
    }
    
    
}