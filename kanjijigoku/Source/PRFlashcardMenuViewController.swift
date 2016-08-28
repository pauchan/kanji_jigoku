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

class PRFlashcardMenuViewController : UITableViewController, UITextFieldDelegate
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
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self._headerCoordinator?.updateHeaderState()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
    if(indexPath.section == 0)
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PRHeaderViewCell", forIndexPath: indexPath) as! PRHeaderViewCell
        _headerCoordinator = PRHeaderCoordinator(headerCell: cell)
        cell.contentView.userInteractionEnabled = false
        cell.selectionStyle = .None
        return cell
        
    }
        else
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PRFlashcardCell", forIndexPath: indexPath) 
        cell.textLabel?.text = _tableItems[indexPath.row] as? String
        cell.textLabel?.font = UIFont().appFontOfSize(20.0)
        cell.textLabel?.textAlignment = .Center
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
            
                let toast : UIAlertView = UIAlertView(title: "Brak fiszek", message: "Brak fiszek dla zadanej kategorii", delegate: self, cancelButtonTitle: "Zamknij")
                toast.show()
                return
            }
            
            flashcardsArray = self.randomizeFlashcardsOrder(flashcardsArray)
            let vc = PRFlashcardPageViewController(flashcardSet: flashcardsArray)
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(indexPath.section == 0) {
            return 90.0*scaleForDevice
        } else {
            return 80.0*scaleForDevice
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    if(section == 0) {
        return 1
    } else {
        return _tableItems.count
    }
}
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func generateFlashcardsArrayForReadings(characters: [Kanji], option: Int) -> [Flashcard]
    {
        
        var returnArray : [Flashcard] = [Flashcard]()
        for kanji in characters
        {
            if(option == kOnyomiOption){
                returnArray.append(Flashcard(text: kanji.kanji!, reading: kanji.generateReadingString(kanji.onyomis!), meaning: kanji.meaning!, type: .Onyomi))
            }
            else // option == kKunyomiOption
            {
                returnArray.append(Flashcard(text: kanji.kanji!, reading: kanji.generateReadingString(kanji.kunyomis!), meaning: kanji.meaning!, type: .Kunyomi))
            }
        }
        return returnArray
    }
    
    func generateFlashcardsArrayForExamples(characters: [Kanji], option : Int) -> [Flashcard] {
        
        var returnArray : [Flashcard] = [Flashcard]()
        for character in characters {
            if(option == kExamplesOption) {
                for e in character.examples! {
                    let example = e as! Example
                    if example.obligatory {
                        let flashcard = Flashcard(text: example.example!, reading: example.reading!, meaning: example.meaning!, type: .Example)
                        // in case filtering distinct flashcards is needed
                        //let array = returnArray.filter({(f: Flashcard) in f.text == flashcard.text && f.reading == flashcard.reading})
                        returnArray.append(flashcard)
                    }
                }
            }
            else
            {
                debugLog("for kanji \(character.kanji) sententces count \(character.sentences!.count)")
                for s in character.sentences!
                {
                    let sentence = s as! Sentence
                    if sentence.obligatory {
                        let flashcard = Flashcard(text: sentence.sentence!, reading: sentence.sentence!, meaning: sentence.meaning!, type: .Sentence)
                        returnArray.append(flashcard)
                    }
                }
            }
        }
        return returnArray
    }
    
    func randomizeFlashcardsOrder(var flashcards : [Flashcard]) -> [Flashcard] {
        
        var newArray: [Flashcard] = [Flashcard]()
        var oldCount = flashcards.count
        while oldCount > 0 {
            let newCount = Int(arc4random_uniform(UInt32(oldCount)))
            newArray.append(flashcards[newCount])
            flashcards.removeAtIndex(newCount)
            oldCount--
        }
        return newArray
    }
}
