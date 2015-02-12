//
//  PRFlashcardViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRFlashcardViewController : UIViewController {

    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    var flashcard : Character = Character()
    
    var tapCount : Int = 0;
    
    override func viewDidLoad() {
        
        characterLabel?.text = flashcard.kanji
        readingLabel?.text = "test"//flashcard.reading
        meaningLabel?.text = "test" //flashcard.meaning
    }
    
    @IBAction func tapReceived(sender: UITapGestureRecognizer) {
        
        tapCount++
        if tapCount == 1
        {
            readingLabel.hidden = false
        }
        else if tapCount == 2
        {
            readingLabel.hidden = false
        }
        else
        {
            // do nothing
        }
        
    }


}
