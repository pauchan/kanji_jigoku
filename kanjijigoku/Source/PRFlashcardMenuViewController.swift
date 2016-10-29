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
    
    if let path = Bundle.main.path(forResource: "flashcardItems", ofType: "plist") {
        self._tableItems = NSArray(contentsOfFile: path)!
    }
    else
    {
        self._tableItems = []
    }
    //self.tableView.keyboardDismissMode = .OnDrag
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .plain,  target: self, action: "prKanjiJigokuRightBarItemShowSettings:")
    self.navigationItem.title = "Fiszki"
    // Do any additional setup after loading the view, typically from a nib.
    let nib : UINib = UINib(nibName: "PRHeaderViewCell", bundle: nil)
    self.tableView.register(nib, forCellReuseIdentifier: "PRHeaderViewCell")
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PRFlashcardCell")
    self.tableView.tableFooterView = UIView()
    
}
    
    override func viewWillAppear(_ animated: Bool)
    {
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
        cell.textLabel?.text = _tableItems[(indexPath as NSIndexPath).row] as? String
        cell.textLabel?.font = UIFont().appFontOfSize(20.0)
        cell.textLabel?.textAlignment = .center
        return cell
    }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath as NSIndexPath).section != 0
        {
            let charactersArray = PRDatabaseHelper().getSelectedObjects("Kanji", level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson)
            var flashcardsArray : [Flashcard]
            if((indexPath as NSIndexPath).row == kKunyomiOption || (indexPath as NSIndexPath).row == kOnyomiOption)
            {
                flashcardsArray = self.generateFlashcardsArrayForReadings(charactersArray as! [Kanji], option: (indexPath as NSIndexPath).row)
            }
            else if((indexPath as NSIndexPath).row == kExamplesOption || (indexPath as NSIndexPath).row == kSentenceOption)
            {
                flashcardsArray = self.generateFlashcardsArrayForExamples(charactersArray as! [Kanji], option: (indexPath as NSIndexPath).row)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if((indexPath as NSIndexPath).section == 0) {
            return 90.0*scaleForDevice
        } else {
            return 80.0*scaleForDevice
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    if(section == 0) {
        return 1
    } else {
        return _tableItems.count
    }
}
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func generateFlashcardsArrayForReadings(_ characters: [Kanji], option: Int) -> [Flashcard]
    {
        
        var returnArray : [Flashcard] = [Flashcard]()
        for kanji in characters
        {
            if(option == kOnyomiOption){
                returnArray.append(Flashcard(text: kanji.kanji!, reading: kanji.generateReadingString(kanji.onyomis!), meaning: kanji.meaning!, type: .onyomi))
            }
            else // option == kKunyomiOption
            {
                returnArray.append(Flashcard(text: kanji.kanji!, reading: kanji.generateReadingString(kanji.kunyomis!), meaning: kanji.meaning!, type: .kunyomi))
            }
        }
        return returnArray
    }
    
    func generateFlashcardsArrayForExamples(_ characters: [Kanji], option : Int) -> [Flashcard] {
        
        var returnArray : [Flashcard] = [Flashcard]()
        for character in characters {
            if(option == kExamplesOption) {
                for e in character.examples! {
                    let example = e as! Example
                    if example.obligatory {
                        let flashcard = Flashcard(text: example.example!, reading: example.reading!, meaning: example.meaning!, type: .example)
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
                        let flashcard = Flashcard(text: sentence.sentence!, reading: sentence.sentence!, meaning: sentence.meaning!, type: .sentence)
                        returnArray.append(flashcard)
                    }
                }
            }
        }
        return returnArray
    }
    
    func randomizeFlashcardsOrder(_ flashcards : [Flashcard]) -> [Flashcard] {
        var flashcards = flashcards
        
        var newArray: [Flashcard] = [Flashcard]()
        var oldCount = flashcards.count
        while oldCount > 0 {
            let newCount = Int(arc4random_uniform(UInt32(oldCount)))
            newArray.append(flashcards[newCount])
            flashcards.remove(at: newCount)
            oldCount -= 1
        }
        return newArray
    }
}
