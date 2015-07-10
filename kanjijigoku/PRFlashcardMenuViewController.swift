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

class PRFlashcardMenuViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    var _tableItems : NSArray!
    var _headerCoordinator : PRHeaderCoordinator!

    
override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Fiszki"
    
    if let path = NSBundle.mainBundle().pathForResource("flashcardItems", ofType: "plist") {
        self._tableItems = NSArray(contentsOfFile: path)!
    }
    else
    {
        self._tableItems = []
    }
    
    //self.tableView.keyboardDismissMode = .OnDrag
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .Plain,  target: self, action: "prKanjiJigokuRightBarItemShowSettings:")
    self.navigationItem.title = "Fiszki"
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
        let cell = tableView.dequeueReusableCellWithIdentifier("PRFlashcardCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = _tableItems[indexPath.row] as? String
        return cell
    }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section != 0
        {
            let charactersArray = PRDatabaseHelper().getSelectedObjects("Kanji", level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson)
            var flashcardsArray : [Flashcard]
            if(indexPath.row == kKunyomiOption || indexPath.row == kOnyomiOption)
            {
                flashcardsArray = self.generateFlashcardsArrayForReadings(charactersArray as! [Kanji], option: indexPath.row)
            }
            else if(indexPath.row == kExamplesOption || indexPath.row == kSentenceOption)
            {
                flashcardsArray = self.generateFlashcardsArrayForExamples(charactersArray as! [Kanji], option: indexPath.row)
            }
            else // customFlashcardToImplement
            {
                flashcardsArray = []
            }
            if flashcardsArray.count == 0 {
            
                var toast : UIAlertView = UIAlertView(title: "Brak fiszek", message: "Brak fiszek dla zadanej kategorii", delegate: self, cancelButtonTitle: "Zamknij")
                toast.show()
                return
            }

            var vc = PRFlashcardPageViewController()
            vc._flashcardSet = flashcardsArray
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
    
    func generateFlashcardsArrayForReadings(characters: [Kanji], option: Int) -> [Flashcard]
    {
        
        var returnArray : [Flashcard] = [Flashcard]()
        for kanjiKanji in characters
        {
            if(option == kOnyomiOption){
                returnArray.append(Flashcard(text: kanjiKanji.kanji, reading: kanjiKanji.generateReadingString(kanjiKanji.onyomis), meaning: kanjiKanji.meaning))
            }
            else // option == kKunyomiOption
            {
                returnArray.append(Flashcard(text: kanjiKanji.kanji, reading: kanjiKanji.generateReadingString(kanjiKanji.kunyomis), meaning: kanjiKanji.meaning))
            }
        }
        return returnArray
    }
    
    func generateFlashcardsArrayForExamples(characters: [Kanji], option : Int) -> [Flashcard]
    {
        
        var returnArray : [Flashcard] = [Flashcard]()
        for character in characters
        {
            if(option == kExamplesOption)
            {
                for e in character.examples
                {
                    let example = e as! Example
                    if example.isObligatory() {
                        returnArray.append(Flashcard(text: example.example, reading: example.reading, meaning: example.meaning))
                    }
                }
            }
            else
            {
                for s in character.sentences
                {
                    let sentence = s as! Sentence
                    if sentence.isObligatory() {
                        let flashcard = Flashcard(text: sentence.sentence, reading: sentence.sentence, meaning: sentence.meaning)
                        flashcard.furiganaReading = sentence.replaceExplainedSentence(sentence.sentence)
                        flashcard.text = (sentence.replaceExplainedSentence(sentence.sentence)).string
                        returnArray.append(flashcard)
                    }
                }
            }
        }
        return returnArray
    }
}
