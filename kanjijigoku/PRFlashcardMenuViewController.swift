//
//  PRFlashcardViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

let kOnyomiOption : Int = 0
let kKunyomiOption : Int = 1
let kExamplesOption : Int = 2
let kSentenceOption : Int = 3
let kCustomFlashCardOption : Int = 4

class PRFlashcardMenuViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate
{
    var _tableItems : NSArray
    var _flashcardItems = ["Onyomi", "Kunyomi", "Example", "Sentence"]

    override init(style: UITableViewStyle) {
        
        if let path = NSBundle.mainBundle().pathForResource("flashcardItems", ofType: "plist") {
            self._tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }
        super.init(style: style)
    }

    override init() {
        
        if let path = NSBundle.mainBundle().pathForResource("flashcardItems", ofType: "plist") {
            self._tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }
        super.init()
        
    }

    required init(coder aDecoder: NSCoder) {
        
        if let path = NSBundle.mainBundle().pathForResource("flashcardItems", ofType: "plist") {
            _tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }
        

        super.init(coder: aDecoder)

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        if let path = NSBundle.mainBundle().pathForResource("flashcardItems", ofType: "plist") {
            _tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }
        super.init(nibName : nibNameOrNil, bundle : nibBundleOrNil)
    }
    
override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "settings")
    self.navigationItem.title = "Kanji Jigoku"
    // Do any additional setup after loading the view, typically from a nib.
    let nib : UINib = UINib(nibName: "PRHeaderViewCell", bundle: nil)
    self.tableView.registerNib(nib, forCellReuseIdentifier: "PRHeaderViewCell")
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRFlashcardCell")
    self.tableView.tableFooterView = UIView()
    
    let test = PRStateSingleton.sharedInstance.levelArray
    for bla in test
    {
        println("test: \(bla)")
    }
    
    

    
}

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
    if(indexPath.section == 0)
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PRHeaderViewCell", forIndexPath: indexPath) as PRHeaderViewCell
        cell.levelComboBox.pickerView.delegate = self;
        cell.lessonComboBox.pickerView.delegate = self;
        
        cell.levelComboBox.pickerView.dataSource = self;
        cell.lessonComboBox.pickerView.dataSource = self;
        
        cell.levelComboBox.tag = 11
        cell.lessonComboBox.tag = 12
        
        cell.levelComboBox.setPickerTag(11)
        cell.lessonComboBox.setPickerTag(12)
        
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
            if indexPath.row < kCustomFlashCardOption // just for now, I need to think about custom flashcards
            {
                //var dbHelp =
                let charactersArray = PRDatabaseHelper().getSelectedObjects("Character", level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson)
                var flashcardsArray : [Flashcard]
                if(indexPath.row == kKunyomiOption || indexPath.row == kOnyomiOption)
                {
                    flashcardsArray = self.generateFlashcardsArrayForReadings(charactersArray as [Character], option: indexPath.row)
                }
                else if(indexPath.row == kExamplesOption || indexPath.row == kSentenceOption)
                {
                    flashcardsArray = self.generateFlashcardsArrayForExamples(charactersArray as [Character], option: indexPath.row)
                }
                else // customFlashcardToImplement
                {
                    flashcardsArray = []
                }

                var vc = PRFlashcardPageViewController()
                vc._flashcardSet = flashcardsArray
                navigationController?.pushViewController(vc, animated: false)
            }
            
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
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 11
        {
            return PRStateSingleton.sharedInstance.levelArray.count
        }
        else
        {
            return PRStateSingleton.sharedInstance.lessonArray.count
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 11
        {
            let bla = PRStateSingleton.sharedInstance.levelArray
            return "Poziom \(PRStateSingleton.sharedInstance.levelArray[row])"
        }
        else
        {
        
            return "Lekcja \(PRStateSingleton.sharedInstance.lessonArray[row])"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let cell : PRHeaderViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as PRHeaderViewCell
        
        if pickerView.tag == 11
        {
            PRStateSingleton.sharedInstance.currentLevel = PRStateSingleton.sharedInstance.levelArray[row] as Int
            cell.levelComboBox.text = "Poziom: \(PRStateSingleton.sharedInstance.currentLevel)"
            cell.lessonComboBox.becomeFirstResponder()
        }
        else
        {
            PRStateSingleton.sharedInstance.currentLesson = PRStateSingleton.sharedInstance.lessonArray[row] as Int
            cell.lessonComboBox.text = "Lekcja: \(PRStateSingleton.sharedInstance.currentLesson)"
            cell.lessonComboBox.resignFirstResponder()
            
        }
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
    
    func generateFlashcardsArrayForExamples(characters: [Character], option : Int) -> [Flashcard]
    {
        
        var returnArray : [Flashcard] = [Flashcard]()
        for character in characters
        {
            if(option == kExamplesOption)
            {
                for e in character.examples
                {
                    let example = e as Example
                    returnArray.append(Flashcard(text: example.example, reading: example.reading, meaning: example.meaning))
                }
            }
            else
            {
                for s in character.sentences
                {
                    let sentence = s as Sentence
                    returnArray.append(Flashcard(text: sentence.sentence, reading: sentence.sentence, meaning: sentence.meaning))
                }
            }
        }
        return returnArray
    }
    


}

