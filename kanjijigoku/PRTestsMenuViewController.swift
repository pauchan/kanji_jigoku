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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .Plain,  target: self, action: "prKanjiJigokuRightBarItemShowSettings:")
        self.navigationItem.title = "Testy"
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
            let cell = tableView.dequeueReusableCellWithIdentifier("PRHeaderViewCell", forIndexPath: indexPath) as! PRHeaderViewCell
            _headerCoordinator = PRHeaderCoordinator(headerCell: cell)
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRFlashcardCell", forIndexPath: indexPath) 
            let testDict = _tableItems[indexPath.row] as! [String: String]
            cell.textLabel?.text = testDict["label"]
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section != 0
        {
    
                let vc = PRTestViewController(nibName: "PRTestViewController", bundle: nil)
                let testDict : [String: String] = _tableItems[indexPath.row] as! [String: String]
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

    
    func generateTest(testDict: [String:String]) -> [Question]
    {
        var newResponse: [Question] = [Question]()
        
        if testDict["questionObject"] != nil && testDict["questionProperty"] != nil && testDict["answerProperty"] != nil
        {
            // 1. fetch all the objects for the given lesson
            let wideArray = PRDatabaseHelper().getSelectedObjects(testDict["questionObject"]!, level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson)
            
            // 2. randomly select 10 of them
            let idsArray = PRDatabaseHelper().generateRandomIdsArray(10, arrayCount: wideArray.count)
            
            for selectedId in idsArray
            {

                let object: AnyObject = wideArray[selectedId]
                let questionString : String = object.valueForKey(testDict["questionProperty"]!) as! String
                
                
                let properAnswer = object.valueForKey(testDict["answerProperty"]!) as! String
                
                // 3. for each assign 3 wrong answer for each type
                var falseAnswers : [String]
                if testDict["questionObject"]! == "Kunyomi" && testDict["answerProperty"]! == "meaning"
                {
                    let kunyomiObject = object as! Kunyomi
                    falseAnswers = PRDatabaseHelper().fetchFalseAnswers(testDict["questionObject"]!, property: testDict["answerProperty"]!, properAnswer: properAnswer, partOfSpeechIndex: Int(kunyomiObject.speechPart), maxLevel: PRStateSingleton.sharedInstance.currentLevel, maxLesson: PRStateSingleton.sharedInstance.currentLesson)
                }
                else
                {
                    falseAnswers = PRDatabaseHelper().fetchFalseAnswers(testDict["questionObject"]!, property: testDict["answerProperty"]!, properAnswer: properAnswer, partOfSpeechIndex:0, maxLevel: PRStateSingleton.sharedInstance.currentLevel, maxLesson: PRStateSingleton.sharedInstance.currentLesson)
                }

                let meaning = object.valueForKey("meaning") as! String
                print("Meanning: \(meaning)")

                let question = Question(question: questionString, correctOption: properAnswer,  falseOptions: falseAnswers, meaning: meaning)
                newResponse.append(question)
            }
        }
        return newResponse
        
    }
    
    
}