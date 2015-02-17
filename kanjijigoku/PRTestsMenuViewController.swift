//
//  PRTestsViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

enum TestOptions: Int {

    case kKanjiOnyomiTest = 0, kKanjiKunyomiTest, kOnyomiKanjiTest, kKunyomiKanjiTest, kKanjiMeaningTest, kKunyomiMeaningTest, kExampleMeaningTest, kMeaningExampleTest
}

class PRTestMenuViewController : UITableViewController, UITextFieldDelegate
{
    var _tableItems : NSArray!
    var _levelDataSource : PRPickerDataSource!
    var _lessonDataSource : PRPickerDataSource!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("testItems", ofType: "plist") {
            self._tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }
        
        _levelDataSource = PRPickerDataSource()
        _lessonDataSource = PRPickerDataSource()
        
        _levelDataSource.sourceArray = PRStateSingleton.sharedInstance.levelArray
        _lessonDataSource.sourceArray = PRStateSingleton.sharedInstance.lessonArray
        
        _levelDataSource.additionalLabel = "Poziom"
        _lessonDataSource.additionalLabel = "Lekcja"
        
        self.tableView.keyboardDismissMode = .Interactive
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "settings")
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
            
            cell.levelComboBox.pickerView.delegate = _levelDataSource
            cell.lessonComboBox.pickerView.delegate = _lessonDataSource
            
            cell.levelComboBox.pickerView.dataSource = _levelDataSource
            cell.lessonComboBox.pickerView.dataSource = _lessonDataSource
            
            cell.levelComboBox.delegate = self
            cell.lessonComboBox.delegate = self
            
            cell.levelComboBox.text = "Poziom: \(PRStateSingleton.sharedInstance.currentLevel)"
            cell.lessonComboBox.text = "Lekcja: \(PRStateSingleton.sharedInstance.currentLesson)"
            
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRFlashcardCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = _tableItems[indexPath.row] as? String
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section != 0
        {
    
                var vc = PRTestViewController()
                vc.questions = generateTest(indexPath.row)
                //vc._flashcardSet = flashcardsArray
                navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as PRHeaderViewCell
        
        if textField == cell.levelComboBox
        {
            PRStateSingleton.sharedInstance.currentLevel = _levelDataSource.selectedItem
            cell.levelComboBox.text = "Poziom: \(PRStateSingleton.sharedInstance.currentLevel)"
        }
        else
        {
            PRStateSingleton.sharedInstance.currentLesson = _lessonDataSource.selectedItem
            cell.lessonComboBox.text = "Lekcja: \(PRStateSingleton.sharedInstance.currentLesson)"
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

    
    func generateCrossTableTest(questionType: String, answerType: String) -> [Question]
    {
    
        // 1. fetch all the objects for the given lesson
        
        var wideArray = PRDatabaseHelper().getSelectedObjects(questionType, level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson)
        
        let idsArray = PRDatabaseHelper().generateRandomIdsArray(10, arrayCount: wideArray.count)
        
        var newResponse: [Question] = [Question]()
        for selectedId in idsArray
        {
            let object: AnyObject = wideArray[selectedId]
            let falseAnswers = PRDatabaseHelper().fetchFalseAnswers(questionType, property: answerType, maxLevel: PRStateSingleton.sharedInstance.currentLevel, maxLesson: PRStateSingleton.sharedInstance.currentLesson)
            
            let questionString : String = object.valueForKey(answerType) as String
            
            let question = Question(question: questionString, options: falseAnswers, properAnswerIndex: Int(arc4random_uniform(3)))
            newResponse.append(question)
            //newResponse.append(object.valueForKey(property) as String)
        }
        return newResponse
        // 2. randomly select 10 of them
        // 3. assign 3 wrong answer for each type
        // 4 return 
        
        
        
    }
    
    func generateWithinTableTest(questionType: String, answerType: String) -> [Question]
    {
        return [Question]()
    }
    
    func generateTest(option: Int) -> [Question]
    {
        switch(option)
        {
        case TestOptions.kKanjiOnyomiTest.rawValue:
            return generateCrossTableTest("Character", answerType: "Onyomi")
        case TestOptions.kKanjiKunyomiTest.rawValue:
            return generateCrossTableTest("Character", answerType: "Kunyomi")
        case TestOptions.kKanjiKunyomiTest.rawValue:
            return generateCrossTableTest("Kunyomi", answerType: "Character")
        case TestOptions.kKanjiKunyomiTest.rawValue:
            return generateCrossTableTest("Onyomi", answerType: "Character")
        case TestOptions.kKanjiKunyomiTest.rawValue:
            return generateWithinTableTest("Character", answerType: "Meaning")
        case TestOptions.kKanjiKunyomiTest.rawValue:
            return generateWithinTableTest("Character", answerType: "Kunoymi")
        case TestOptions.kKanjiKunyomiTest.rawValue:
            return generateWithinTableTest("Example", answerType: "meaning")
        case TestOptions.kKanjiKunyomiTest.rawValue:
            return generateWithinTableTest("Example", answerType: "example")
        default:
            return [Question]()
        
        
        }
    
    
    }
    
    
}