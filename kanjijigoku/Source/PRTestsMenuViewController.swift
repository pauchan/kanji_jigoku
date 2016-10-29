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
        
        if let path = Bundle.main.path(forResource: "testPairing", ofType: "plist") {
            self._tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }

        self.tableView.keyboardDismissMode = .interactive
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .plain,  target: self, action: "prKanjiJigokuRightBarItemShowSettings:")
        self.navigationItem.title = "Testy"
        // Do any additional setup after loading the view, typically from a nib.
        let nib : UINib = UINib(nibName: "PRHeaderViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "PRHeaderViewCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PRFlashcardCell")
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewDidAppear(animated)
        self._headerCoordinator?.updateHeaderState()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if((indexPath as NSIndexPath).section == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRHeaderViewCell", for: indexPath) as! PRHeaderViewCell
            _headerCoordinator = PRHeaderCoordinator(headerCell: cell)
            cell.contentView.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRFlashcardCell", for: indexPath) 
            let testDict = _tableItems[(indexPath as NSIndexPath).row] as! [String: String]
            cell.textLabel?.font = UIFont().appFontOfSize(12.0)
            cell.textLabel?.text = testDict["label"]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath as NSIndexPath).section != 0
        {
    
                let vc = PRTestViewController(nibName: "PRTestViewController", bundle: nil)
                let testDict : [String: String] = _tableItems[(indexPath as NSIndexPath).row] as! [String: String]
                vc.questions = generateTest(testDict)
                vc.descriptionText = testDict["label"]!
                navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if((indexPath as NSIndexPath).section == 0)
        {
            return 90.0*scaleForDevice
        }
        else
        {
            return 45.0*scaleForDevice
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    func generateTest(_ testDict: [String:String]) -> [Question]
    {
        var newResponse: [Question] = [Question]()
        
        if testDict["questionObject"] != nil && testDict["questionProperty"] != nil && testDict["answerProperty"] != nil
        {
            // 1. fetch all the objects for the given lesson
            let wideArray = PRDatabaseHelper().getSelectedObjects(testDict["questionObject"]!, level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson)
            
            // 2. randomly select 10 of them
            let idsArray = PRDatabaseHelper().generateRandomIdsArray(10, arrayCount: wideArray.count)
            
            for selectedId in idsArray {

                let object = wideArray[selectedId] as AnyObject
                let questionString : String = object.value(forKey: testDict["questionProperty"]!) as! String
                
                let properAnswer = object.value(forKey: testDict["answerProperty"]!) as! String
                
                // 3. for each assign 3 wrong answer for each type
                var falseAnswers : [String]
                if testDict["questionObject"]! == "Kunyomi" && testDict["answerProperty"]! == "meaning"
                {
                    let kunyomiObject = object as! Kunyomi
                    falseAnswers = PRDatabaseHelper().fetchFalseAnswers(testDict["questionObject"]!, property: testDict["answerProperty"]!, properAnswer: properAnswer, partOfSpeechIndex: Int(kunyomiObject.speechPart), maxLevel: PRStateSingleton.sharedInstance.currentLevel, maxLesson: PRStateSingleton.sharedInstance.currentLesson)
                } else {
                    falseAnswers = PRDatabaseHelper().fetchFalseAnswers(testDict["questionObject"]!, property: testDict["answerProperty"]!, properAnswer: properAnswer, partOfSpeechIndex:0, maxLevel: PRStateSingleton.sharedInstance.currentLevel, maxLesson: PRStateSingleton.sharedInstance.currentLesson)
                }
                var meaning: String = ""
                if testDict["questionObject"]! == "Onyomi" && testDict["questionProperty"]! == "kanji" {
                    let onyomi = object as! Onyomi
                    meaning = (onyomi.character?.meaning!)!
                } else {
                    meaning = object.value(forKey: "meaning") as! String
                }
                
                let question = Question(question: questionString, correctOption: properAnswer,  falseOptions: falseAnswers, meaning: meaning)
                newResponse.append(question)
            }
        }
        return newResponse
    }
    
    
}
